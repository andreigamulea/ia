class StripeWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  # Definim o hartă care asociază fiecare cod cu luna corespunzătoare
  MAP_COD_LUNA = {
    "cod16" => :octombrie,
    "cod17" => :noiembrie,
    "cod18" => :decembrie,
    "cod19" => :ianuarie,
    "cod20" => :februarie,
    "cod21" => :martie,
    "cod22" => :aprilie,
    "cod23" => :mai,
    "cod24" => :iunie,
    "cod25" => :iulie
  }
  MAP_COD_TAXA = {
    "cod16" => 2,
    "cod17" => 3,
    "cod18" => 4,
    "cod19" => 5,
    "cod20" => 6,
    "cod21" => 7,
    "cod22" => 8,
    "cod23" => 9,
    "cod24" => 10,
    "cod25" => 11
}.freeze

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
    numar_comanda = metadata[:numar_comanda] #am verificat: id este la fel cu numar_comanda in orice situatie chiar daca sterg records!!
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
      cp = ComenziProd.find_by(comanda_id: numar_comanda)
      cp.update(validat: 'Finalizata')
      #1start creaza o inregistrare in accescurs2324 dc nu exista iar daca exista fa doar update (pt taxa inscriere an 1)      
      if produs.cod == "cod14"
        user = User.find_by(id: user_id)

        user.update(grupa: 1)
        unless cp.update(taxa2324: 1)
          # Cod pentru tratamentul erorilor
          Descriereerori.create(descriere: "Eroare in stripe_webhooks: taxa2324 pt taxa inscriere nu a fost pusa  #{produs.cod}
          pt #{current_user.name}")
        else
          # Caută o înregistrare existentă sau inițializează una nouă
          acces = Accescurs2324.find_or_initialize_by(user_id: user_id)
          
          if acces.new_record?
            # Dacă este o nouă înregistrare (nu a fost găsită în baza de date)
            acces.septembrie = true
            acces.save
          else
            # Dacă este o înregistrare existentă, actualizează valorile necesare
            acces.update(septembrie: true)
          end
        end
      end
      #1end
      #2start creaza o inregistrare in accescurs2324 dc nu exista iar daca exista fa doar update (pt taxa inscriere an 1)      
      if produs.cod == "cod15" #cand se plateste taxa anuala1620 lei
        unless cp.update(taxa2324: 12)
          # Cod pentru tratamentul erorilor
          Descriereerori.create(descriere: "Eroare in stripe_webhooks: taxa2324 pt taxa inscriere nu a fost pusa  #{produs.cod}
          pt #{current_user.name}")
        else
          # Caută o înregistrare existentă sau inițializează una nouă
          acces = Accescurs2324.find_or_initialize_by(user_id: user_id)
          
          luni_hash = {
            septembrie: true,
            octombrie: true,
            noiembrie: true,
            decembrie: true,
            ianuarie: true,
            februarie: true,
            martie: true,
            aprilie: true,
            mai: true,
            iunie: true,
            iulie: true,
            all: true
          }
          
          if acces.new_record?
            # Dacă este o nouă înregistrare (nu a fost găsită în baza de date)
            luni_hash.each do |luna, val|
              acces[luna] = val
            end
            acces.save
          else
            # Dacă este o înregistrare existentă, actualizează valorile necesare
            acces.update(luni_hash)
          end
          
        end
      end
      #2end
    ############################
    
   
    # Verificăm dacă codul produsului se află în lista de coduri pe care o avem
    if MAP_COD_LUNA.key?(produs.cod)
      valoare_taxa = MAP_COD_TAXA[produs.cod]
      
      unless cp.update(taxa2324: valoare_taxa)
        # Cod pentru tratamentul erorilor
        Descriereerori.create(descriere: "Eroare in stripe_webhooks: taxa2324 nu a fost pusa pentru #{produs.cod} pt #{current_user.name}")
      else
        # Caută o înregistrare existentă sau inițializează una nouă
        acces = Accescurs2324.find_or_initialize_by(user_id: user_id)
        
        luna_curenta = MAP_COD_LUNA[produs.cod]

        if acces.new_record?
          # Dacă este o nouă înregistrare (nu a fost găsită în baza de date)
          acces[luna_curenta] = true
          acces.save
        else
          # Dacă este o înregistrare existentă, actualizează valorile necesare
          acces.update(luna_curenta => true)
        end
      end
    end

    ###########################
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
    if !['cod11', 'cod12', 'cod13', 'cod14', 'cod15', 'cod16', 'cod17', 'cod18', 'cod19', 'cod20', 'cod21',
       'cod22', 'cod23', 'cod24', 'cod25', 'cod26', 'cod27', 'cod28', 'cod29',
       'cod30', 'cod31', 'cod32', 'cod33', 'cod34', 'cod35', 'cod36', 'cod37',
       'cod38', 'cod39', 'cod40', 'cod41', 'cod42', 'cod43', 'cod44', 'cod45'].include?(produs.cod)
      produsul = produs.nume + ' (' + Date.current.strftime("%d-%m-%Y") + ' - ' + (Date.current + dt.days).strftime("%d-%m-%Y") + ' )'
    else
      produsul = produs.nume
    end
    

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


