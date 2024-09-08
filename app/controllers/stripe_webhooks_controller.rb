class StripeWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  # Definim o hartă care asociază fiecare cod cu luna corespunzătoare
  # Definirea constantei pentru lunile și taxele corespunzătoare pentru 2023-2024
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
}.merge("cod14" => :septembrie, "cod15" => :all).freeze

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
}.merge("cod14" => 1, "cod15" => 12).freeze

# Definirea constantei pentru lunile și taxele corespunzătoare pentru 2024-2025
MAP_COD_LUNA_2425 = {
  "cod197" => :octombrie,
  "cod198" => :noiembrie,
  "cod199" => :decembrie,
  "cod200" => :ianuarie,
  "cod201" => :februarie,
  "cod202" => :martie,
  "cod203" => :aprilie,
  "cod204" => :mai,
  "cod205" => :iunie,
  "cod206" => :iulie,
  "cod207" => :septembrie
}.freeze

MAP_COD_TAXA_2425 = {  
  "cod197" => 2,
  "cod198" => 3,
  "cod199" => 4,
  "cod200" => 5,
  "cod201" => 6,
  "cod202" => 7,
  "cod203" => 8,
  "cod204" => 9,
  "cod205" => 10,
  "cod206" => 11,
  "cod207" => 1
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
    cantitate = payment_intent["metadata"]["cantitate"]
    pret_bucata = (payment_intent["metadata"]["pret_bucata"]).to_d
    pret_total = payment_intent["metadata"]["pret_total"]
    puts("cantitate: #{cantitate}")
    # Acum, găsești comanda în baza de date folosind numar_comanda și o actualizezi
    comanda = Comanda.find_by(numar: numar_comanda)
      
    if comanda
      payment_method_id = payment_intent.payment_method
      payment_method = Stripe::PaymentMethod.retrieve(payment_method_id)
          
      # Acum puteți accesa adresa de email a clientului
      customer_email = payment_method.billing_details.email
      if metadata[:email]=='nagy.edvin@yahoo.com' && ['cod16', 'cod17', 'cod18', 'cod19', 'cod20', 'cod21',
        'cod22', 'cod23', 'cod24', 'cod25', 'cod207', 'cod197', 'cod198', 'cod199', 'cod200', 'cod201', 'cod202', 'cod203',
         'cod204', 'cod205', 'cod206'].include?(produs.cod)
        produs.pret=35
      end  


      comanda.update(
        statecomanda2: 'Finalizata',
        stateplata1: 'Achitata',
        plataprin: 'Stripe',
        stateplata2: "#{pret_total} lei",
        total: pret_total,
        stateplata3: "acces #{produs.valabilitatezile} zile",
        emailcurrent: emailplata,
        emailplata: customer_email
      )
      cp = ComenziProd.find_by(comanda_id: numar_comanda)
      cp.update(validat: 'Finalizata')

      case produs.cod
      when 'cod72'
        UserModulecursuri.create(user_id: user_id, modulecursuri_id: 3, validat: 'Finalizata')
      when 'cod73'
        UserModulecursuri.create(user_id: user_id, modulecursuri_id: 1, validat: 'Finalizata')
        UserModulecursuri.create(user_id: user_id, modulecursuri_id: 2, validat: 'Finalizata')
      when 'cod76'
        UserModulecursuri.create(user_id: user_id, modulecursuri_id: 2, validat: 'Finalizata')
      end

      # Cod pentru anul 2023-2024
if produs.cod == "cod14"
  user = User.find_by(id: user_id)

  user.update(grupa: 1)
  unless cp.update(taxa2324: 1)
    Descriereerori.create(descriere: "Eroare in stripe_webhooks: taxa2324 pt taxa inscriere nu a fost pusa #{produs.cod} pt #{current_user.name}")
  else
    acces = Accescurs2324.find_or_initialize_by(user_id: user_id)
    
    if acces.new_record?
      acces.septembrie = true
      acces.save
    else
      acces.update(septembrie: true)
    end
  end
end

if produs.cod == "cod15"
  unless cp.update(taxa2324: 12)
    Descriereerori.create(descriere: "Eroare in stripe_webhooks: taxa2324 pt taxa inscriere nu a fost pusa #{produs.cod} pt #{current_user.name}")
  else
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
      luni_hash.each do |luna, val|
        acces[luna] = val
      end
      acces.save
    else
      acces.update(luni_hash)
    end
  end
end

if MAP_COD_LUNA.key?(produs.cod)
  valoare_taxa = MAP_COD_TAXA[produs.cod]
  
  unless cp.update(taxa2324: valoare_taxa)
    Descriereerori.create(descriere: "Eroare in stripe_webhooks: taxa2324 nu a fost pusa pentru #{produs.cod} pt #{current_user.name}")
  else
    acces = Accescurs2324.find_or_initialize_by(user_id: user_id)
    luna_curenta = MAP_COD_LUNA[produs.cod]
    
    if acces.new_record?
      acces[luna_curenta] = true
      acces.save
    else
      acces.update(luna_curenta => true)
    end
  end
end

# start Cod pentru anul 2024-2025
if produs.cod == "cod195"
  user = User.find_by(id: user_id)

  user.update(grupa2425: 1)
  unless cp.update(taxa2425: 1)
    Descriereerori.create(descriere: "Eroare in stripe_webhooks: taxa2425 pt taxa inscriere nu a fost pusa #{produs.cod} pt #{current_user.name}")
  else
    acces = Accescurs2425.find_or_initialize_by(user_id: user_id)
    
    if acces.new_record?
      acces.septembrie = true
      acces.save
    else
      acces.update(septembrie: true)
    end
  end
end

if produs.cod == "cod196"
  unless cp.update(taxa2425: 12)
    Descriereerori.create(descriere: "Eroare in stripe_webhooks: taxa2425 pt taxa inscriere nu a fost pusa #{produs.cod} pt #{current_user.name}")
  else
    acces = Accescurs2425.find_or_initialize_by(user_id: user_id)
    
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
      luni_hash.each do |luna, val|
        acces[luna] = val
      end
      acces.save
    else
      acces.update(luni_hash)
    end
  end
end

if MAP_COD_LUNA_2425.key?(produs.cod)
  valoare_taxa = MAP_COD_TAXA_2425[produs.cod]
  
  # Verifică dacă valoarea `taxa2425` deja există și este corectă
  existing_cp = ComenziProd.find_by(user_id: user_id, prod_id: cp.prod_id)
  if existing_cp && existing_cp.taxa2425 == valoare_taxa
    Descriereerori.create(descriere: "Eroare in stripe_webhooks: taxa2425 deja setata la #{valoare_taxa} pentru #{produs.cod} pt #{current_user.name}")
  else
    unless cp.update(taxa2425: valoare_taxa)
      Descriereerori.create(descriere: "Eroare in stripe_webhooks: taxa2425 nu a fost pusa pentru #{produs.cod} pt #{current_user.name}")
    else
      acces = Accescurs2425.find_or_initialize_by(user_id: user_id)
      luna_curenta = MAP_COD_LUNA_2425[produs.cod]
      
      if acces.new_record?
        acces[luna_curenta] = true
        acces.save
      else
        acces.update(luna_curenta => true)
      end
    end
  end
end

    ###########################end an1 2024-2025
      populeaza_cursuri(user_id, produs)
      creaza_factura(payment_intent)
      #send_payment_success_email
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
      puts("nu am gasit curslegatura! pune in Listacursuris acest curs")
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
  

    if !["cod36", "cod37", "cod214", "cod215", "cod216", "cod217", "cod218", "cod219", "cod220", "cod221", "cod222", "cod223", "cod224"].include?(produs.cod)
    # Generează numărul de factură
    ultima_factura = Factura.order(:numar).last
    numar_factura = ultima_factura ? ultima_factura.numar + 1 : 1001
  
    # Calculați valoarea fără TVA
    pret_unitar_fara_tva = produs.pret / (1 + TVA / 100.0)
    if metadata[:email]=='nagy.edvin@yahoo.com' && ['cod16', 'cod17', 'cod18', 'cod19', 'cod20', 'cod21',
      'cod22', 'cod23', 'cod24', 'cod25', 'cod207','cod197', 'cod198', 'cod199', 'cod200', 'cod201', 'cod202', 'cod203', 'cod204', 'cod205', 'cod206'].include?(produs.cod)

      
      pret_unitar_fara_tva = 29.41 #custom
      produs.pret = 35
    end  
    end
    dt = produs.valabilitatezile
    if ![
      'cod11', 'cod12', 'cod13', 'cod14', 'cod15', 'cod16', 'cod17', 'cod18', 'cod19', 'cod20', 'cod21',
      'cod22', 'cod23', 'cod24', 'cod25', 'cod26', 'cod27', 'cod28', 'cod29',
      'cod30', 'cod31', 'cod32', 'cod33', 'cod34', 'cod35', 'cod36', 'cod37',
      'cod38', 'cod39', 'cod40', 'cod41', 'cod42', 'cod43', 'cod44', 'cod45', 'cod48', 'cod76', 'cod85', 'cod86', 'cod88',
      'cod105', 'cod108', 'cod110', 'cod111', 'cod126', 'cod174', 'cod175',
      'cod195', 'cod196', 'cod197', 'cod198', 'cod199', 'cod200', 'cod201', 'cod202', 'cod203', 'cod204','cod205','cod206','cod207','cod213',
      "cod214", "cod215", "cod216", "cod217", "cod218", "cod219", "cod220", "cod221", "cod222", "cod223", "cod224"
    ].include?(produs.cod)
      produsul = produs.nume + ' (' + Date.current.strftime("%d-%m-%Y") + ' - ' + (Date.current + dt.days).strftime("%d-%m-%Y") + ' )'
    
    else
      produsul = produs.nume
    end
    if Date.today < Date.new(2024, 7, 16)
      if ['cod176', 'cod177', 'cod178'].include?(produs.cod)
        produsul = produs.nume + ' (' + Date.new(2024, 7, 16).strftime("%d-%m-%Y") + ' - ' + (Date.new(2024, 7, 16) + dt.days).strftime("%d-%m-%Y") + ' )'
      end
    end
    
    if !["cod36", "cod37", "cod214", "cod215", "cod216", "cod217", "cod218", "cod219", "cod220", "cod221", "cod222", "cod223", "cod224"].include?(produs.cod)
    # Creați o nouă factură
    factura = Factura.create(
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
      status: "Achitata",
      cantitate: payment_intent["metadata"]["cantitate"],
      pret_unitar: ((payment_intent["metadata"]["pret_bucata"]).to_d / BigDecimal("1.19")).round(2),
      
      valoare_tva: TVA,
      valoare_totala: payment_intent["metadata"]["pret_total"]
    )
    else
      factura = Facturaproforma.find_by(comanda_id: comanda.id)
      if factura
        factura.update(
          plata_prin: 'Stripe', 
          data_platii: Date.current, 
          status: 'Achitata'
        )
      end
    end
    if (factura.nume_companie.present? || factura.cui.present?) && Rails.env.production?
      send_payment_success_email(factura)
    end
    
    user = User.find_by(id: metadata[:user_id])

    if user && factura.persisted? && Rails.env.production?   
      puts("daaaaaaaaaaaa") 
      puts("User id este: #{user.id}")  
      PaymentMailer.billing_details_email(user, factura).deliver_now
   
    else
      puts("nuuuuuuuuuuu")  
    end

  end
  def send_payment_success_email(factura)
    PaymentMailer.payment_success_email(factura).deliver_now
  end
  
 
  
end


