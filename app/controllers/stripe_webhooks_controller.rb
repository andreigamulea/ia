class StripeWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
      if Rails.env.development?
        webhook_secret = Rails.application.credentials.dig(:stripe, :development, :webhook_secret)
    elsif Rails.env.production?
        webhook_secret = Rails.application.credentials.dig(:stripe, :production, :webhook_secret)
    end
    
    event = Stripe::Webhook.construct_event(
        payload, sig_header, webhook_secret
    )
    
    rescue JSON::ParserError => e
      # Invalid payload
      status 400
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      status 400
      return
    end
    

    # Handle the event
    case event.type
    when 'payment_intent.succeeded'
      payment_intent = event.data.object # contains a Stripe::PaymentIntent
      # Then define and call a method to handle a successful payment intent.
      handle_payment_intent_succeeded(payment_intent)
    when 'payment_intent.payment_failed'
      payment_intent = event.data.object # contains a Stripe::PaymentIntent
      # Then define and call a method to handle the failed payment intent.
      handle_payment_intent_payment_failed(payment_intent)
    end

    render json: { message: 'success' }
  end

  private

  def handle_payment_intent_succeeded(payment_intent)
    # Aici, presupunem că ai stocat `user_id` și `numar_comanda` în metadata 
    metadata = extract_metadata(payment_intent)
    user_id = metadata[:user_id]
    numar_comanda = metadata[:numar_comanda]
    produs = Prod.find_by(id: metadata[:id_produs])
    emailplata = metadata[:adresaemail]
    # Acum, găsești comanda în baza de date folosind numar_comanda și o actualizezi
    comanda = Comanda.find_by(numar: numar_comanda)
      
    if comanda
      payment_method_id = payment_intent.payment_method
      payment_method = Stripe::PaymentMethod.retrieve(payment_method_id)
          
      # Acum puteți accesa adresa de email a clientului
      customer_email = payment_method.billing_details.email
    
      comanda.update(
        statecomanda2: 'Finalizata',
        stateplata1: 'Achitata',
        stateplata2: "#{produs.pret} lei",
        stateplata3: "acces #{produs.valabilitatezile} zile",
        emailcurrent: emailplata,
        emailplata: customer_email
      )
    
      populeaza_cursuri(user_id, produs)
      creaza_factura(payment_intent)
      #populeaza_cursuri_history(user_id, curs_id, curs, User.find(user_id).email)

    else
      Rails.logger.error "Nu s-a putut găsi comanda cu numarul #{numar_comanda} pentru actualizare"
    end
  
  end

  def handle_payment_intent_payment_failed(payment_intent)
    # Extract metadata
    metadata = extract_metadata(payment_intent)
    numar_comanda = metadata[:numar_comanda]
  
    # Find the order in the database using numar_comanda and update it
    comanda = Comanda.find_by(numar: numar_comanda)
  
    if comanda
      comanda.update(statecomanda2: 'Esuat', stateplata1: 'Eșuat')
    else
      Rails.logger.error "Nu s-a putut găsi comanda cu numarul #{numar_comanda} pentru actualizare"
    end
  end
  def extract_metadata(payment_intent)
    metadata = payment_intent.metadata
    {
      user_id: metadata['user_id'],
      numar_comanda: metadata['numar_comanda'],
      strada: metadata['strada'],
      id_produs: metadata['id_produs'],
      telefon: metadata['telefon'],
      email: metadata['email'],
      judet: metadata['judet'],
      prenume: metadata['prenume'],
      codpostal: metadata['codpostal'],
      updated_at: metadata['updated_at'],
      localitate: metadata['localitate'],
      nume: metadata['nume'],
      numar: metadata['numar'],
      adresaemail: metadata['adresaemail'],
      tara: metadata['tara'],
      cui: metadata['cui'],
      numecompanie: metadata['numecompanie'],
      altedate: metadata['altedate'],
    }
  end
  def populeaza_cursuri(user_id, produs)
    # Logarea datelor de intrare
    Rails.logger.info("Populeaza cursuri pentru user_id: #{user_id}, produs: #{produs.inspect}")
  
    # Cautam id-ul cursului cu numele specificat in produs.curslegatura
    curs_id = Listacursuri.find_by(nume: produs.curslegatura).id
  
    # Verificăm dacă am găsit curs_id
    if curs_id.nil?
      Rails.logger.error("Nu s-a găsit Listacursuri cu numele: #{produs.curslegatura}")
      return
    end
  
    # Cream sau găsim înregistrarea în tabela Cursuri
    curs = Cursuri.find_or_initialize_by(listacursuri_id: curs_id, user_id: user_id)
    
    curs = Cursuri.find_or_create_by(listacursuri_id: curs_id, user_id: user_id)
    if curs.update(
      datainceput: Time.now,
      datasfarsit: Time.now + produs.valabilitatezile.to_i.days,
      sursa: 'Stripe',
      updated_at: Time.now
    )
      #Rails.logger.info("Curs actualizat: #{curs.inspect}")
      
    else
     
      #Rails.logger.error("Eroare la actualizarea cursului: #{curs.errors.full_messages}")
    end
    
  
    # Logarea stării înregistrării după salvare
    #Rails.logger.info("Curs salvat: #{curs.inspect}")
  
    # Apelam noua metoda dupa ce am reusit sa actualizam sau sa cream inregistrarea in tabela Cursuri
    populeaza_cursuri_history(user_id, curs_id, curs, User.find(user_id).email)
  end
  
  def populeaza_cursuri_history(user_id, curs_id, curs, email)
    # Cream o noua inregistrare in tabela CursuriHistory cu informatiile de care avem nevoie
    CursuriHistory.create!(
      user_id: user_id,
      listacursuri_id: curs_id,
      cursuri_id: curs.id,
      datainceput: curs.datainceput,
      datasfarsit: curs.datasfarsit,
      email: email,
      modificatde: 'Stripe'
    )
  end
  def creaza_factura(payment_intent)
    # Extract metadata
    metadata = extract_metadata(payment_intent)
  
    # Identificați comanda și produsul
    comanda = Comanda.find_by(numar: metadata[:numar_comanda])
    produs = Prod.find_by(id: metadata[:id_produs])
  
    # Generează numărul de factură
    ultima_factura = Factura.order(:numar).last
    numar_factura = ultima_factura ? ultima_factura.numar + 1 : 1001
  
    # Calculați valoarea fără TVA
    pret_unitar_fara_tva = produs.pret / (1 + TVA / 100.0)
    dt = produs.valabilitatezile
    produsul = produs.nume + ' (' + Date.current.strftime("%d-%m-%Y") + ' - ' + (Date.current + dt.days).strftime("%d-%m-%Y") + ' )'

    # Creați o nouă factură
    Factura.create(
      comanda_id: comanda.id,
      user_id: metadata[:user_id],
      numar: numar_factura,
      numar_comanda: comanda.numar,
      data_emiterii: Date.current,
      prenume: metadata[:prenume],
      nume: metadata[:nume],
      nume_companie: metadata[:numecompanie],
      cui: metadata[:cui],
      tara: metadata[:tara],
      localitate: metadata[:localitate],
      judet: metadata[:judet],
      cod_postal: metadata[:codpostal],
      strada: metadata[:strada],
      numar_adresa: metadata[:numar],
      produs: produsul,
      cantitate: 1,
      pret_unitar: pret_unitar_fara_tva.round(2),
      valoare_tva: TVA,
      valoare_totala: produs.pret.to_i
    )
  end
  
  
  
end


