class FacturaproformasController < ApplicationController
  require 'bigdecimal'
  require 'bigdecimal/util' # For to_d method
  before_action :set_facturaproforma, only: %i[ show edit update destroy]
  before_action :set_user_admin, only: %i[generare_facturi not_in_users]
  before_action :set_user, only: %i[index show edit update destroy]
  #before_action :reset_stripe_session, only: [:pay1]
  skip_before_action :verify_authenticity_token, only: [:create_stripe_session]
  #skip_before_action :verify_authenticity_token, only: [:create_stripe_session]
  #before_action :set_stripe_key, only: [:pay1, :create_stripe_session]
  before_action :authenticate_user!, except: [:create_stripe_session]
  before_action :set_stripe_key, only: [:create_stripe_session]

  
  # GET /facturaproformas or /facturaproformas.json
  def index
    @facturaproformas = Facturaproforma.all
  end





  def download
    factura = Facturaproforma.find(params[:id])
    # logica pentru generarea PDF-ului aici
  end
  def download1
    if current_user.role==1
    @facturas = Facturaproforma.all # Aici obținem toate facturile
    # Adaugă orice alte verificări de securitate necesare aici
    #puts @facturas.inspect
    respond_to do |format|
      format.html
      format.pdf do
        html = render_to_string(
          template: 'facturas/download1',
          locals: { facturas: @facturas },
          encoding: 'UTF8'
        )
        pdf = PDFKit.new(html).to_pdf
        send_data pdf, filename: "Toate_Facturile.pdf",
          type: 'application/pdf',
          disposition: 'attachment'
      end
    end
  end
  end


  #Functionare plati Stripe:
  #aceasta metoda este apelata de un Buton dintr-un view C:\ia\app\views\facturas\index.html.erb
  # din alt controller Facturas.Butonul are turbo: false. Metoda de mai jos este POST si nu are un View.
  # are un js.erb unde este cod pt Stripe. Enjoy!
  def create_stripe_session
    @factura = Facturaproforma.find(params[:id])
    Rails.logger.info "Factura proforma gasita: #{@factura.inspect}"
  
    @comanda = Comanda.find(@factura.comanda_id)
    Rails.logger.info "Comanda asociata gasita: #{@comanda.inspect}"
  
    @user = User.find(@factura.user_id)
    Rails.logger.info "Utilizatorul asociat gasit: #{@user.inspect}"
  
    @detaliifacturare = DateFacturare.find_by(user_id: @user.id)
    Rails.logger.info "Detalii facturare gasite: #{@detaliifacturare.inspect}"

    @prod = Prod.find(@factura.prod_id)
    Rails.logger.info "Produs asociat gasit: #{@prod.inspect}"
  
    an_record = @detaliifacturare.nil? ? An32324.find_by(email: @user.email) : nil
    Rails.logger.info "Detalii din An32324 gasite: #{an_record.inspect}" if an_record
  
    metadata = {
      user_id: @user.id.to_s,
      email: @user.email,
      numar_comanda: @comanda.id,
      id_produs: @prod.id,
      nume: @detaliifacturare&.nume || an_record&.nume,
      prenume: @detaliifacturare&.prenume || nil,
      numecompanie: @detaliifacturare&.numecompanie || nil,
      cui: @detaliifacturare&.cui || nil,
      tara: @detaliifacturare&.tara || nil,
      strada: @detaliifacturare&.strada || nil,
      numar: @detaliifacturare&.numar || nil,
      altedate: @detaliifacturare&.altedate || nil,
      adresaemail: @detaliifacturare&.adresaemail || nil,
      judet: @detaliifacturare&.judet || nil,
      localitate: @detaliifacturare&.localitate || "Bucuresti",
      codpostal: @detaliifacturare&.codpostal || nil,
      telefon: @detaliifacturare&.telefon || nil,
      updated_at: @detaliifacturare&.updated_at || nil,
      cantitate: @factura.cantitate,
      pret_bucata: @factura.pret_unitar,
      pret_total: @factura.valoare_totala
    }
  
    if @user.stripe_customer_id.nil?
      begin
        customer = Stripe::Customer.create(email: @user.email)
        @user.update(stripe_customer_id: customer.id)
      rescue => e
        Rails.logger.error "Stripe customer creation failed for user #{@user.id}: #{e.message}"
        return
      end
    end
  
    begin
      @session = Stripe::Checkout::Session.create({
        payment_method_types: ['card'],
        line_items: [{
          price_data: {
            currency: 'ron',
            product_data: {
              name: @factura.produs
            },
            unit_amount: (@factura.valoare_totala * 100).to_i,
          },
          quantity: 1,
        }],
        payment_intent_data: {
          metadata: metadata
        },
        mode: 'payment',
        success_url: "#{successtripe_url}?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: root_url,
        metadata: metadata
      })
  
      Rails.logger.info "Stripe session created: #{@session.id}"
  
      respond_to do |format|
        format.html {
          render partial: "facturaproformas/create_stripe_session", locals: { stripe_public_key: @stripe_public_key, session_id: @session.id }
        }
      end
    rescue => e
      Rails.logger.error "Failed to create checkout session: #{e.message}"
      render json: { error: e.message }, status: :internal_server_error
    end
  end
  
  # GET /facturaproformas/1 or /facturaproformas/1.json
  def show
    @factura = Facturaproforma.find(params[:id])
    @df = DateFacturare.find_by(user_id: @factura.user_id)
    @user = User.find_by(id: @factura.user_id)
    @cpa = @user&.cpa || '-'
    @obs = @factura&.obs


    
    if @df.nil?
      @df = DateFacturare.new
      @df.nume=@factura.nume
      puts "nume=#{@df.nume}"
    else
      puts "itsnonil"
    end
    
    preluare_date_furnizor(@factura.cod_firma)
    puts("seriaaa:#{@serie}")
    puts("factura este azi : #{@factura.id}") 
    puts("factura este azi a user: #{@factura.user_id}")
    unless @factura.user_id == @user.id || @user.role == 1
      redirect_to root_path, alert: "Nu aveți permisiunea de a vizualiza această factură"
      return
    end
  
    respond_to do |format|
      format.html
      format.pdf do
        html = render_to_string(
          template: 'facturaproformas/show', # Asigură-te că denumirea și calea sunt corecte
          locals: { factura: @factura },
          encoding: 'UTF8'
        )
        pdf = PDFKit.new(html).to_pdf
        filename_prefix = @factura.numar_factura
        filename = "Factura_#{filename_prefix}_din_#{@factura.data_emiterii.strftime('%d.%m.%Y')}.pdf"
        send_data pdf, filename: filename, type: 'application/pdf', disposition: 'attachment'
      end
    end
  end
  

  # GET /facturaproformas/new
  def new
    @facturaproforma = Facturaproforma.new
  end

  # GET /facturaproformas/1/edit
  def edit
  end

  # POST /facturaproformas or /facturaproformas.json
  def create
    @facturaproforma = Facturaproforma.new(facturaproforma_params)

    respond_to do |format|
      if @facturaproforma.save
        format.html { redirect_to facturaproforma_url(@facturaproforma), notice: "Facturaproforma was successfully created." }
        format.json { render :show, status: :created, location: @facturaproforma }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @facturaproforma.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /facturaproformas/1 or /facturaproformas/1.json
  def update
    respond_to do |format|
      if @facturaproforma.update(facturaproforma_params)
        format.html { redirect_to facturaproforma_url(@facturaproforma), notice: "Facturaproforma was successfully updated." }
        format.json { render :show, status: :ok, location: @facturaproforma }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @facturaproforma.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /facturaproformas/1 or /facturaproformas/1.json
  def destroy
    @facturaproforma.destroy

    respond_to do |format|
      format.html { redirect_to facturaproformas_url, notice: "Facturaproforma was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  def situatii_lunare
    @months = [
      'Ianuarie 2024', 'Februarie 2024', 'Martie 2024', 'Aprilie 2024', 'Mai 2024',
      'Iunie 2024', 'Iulie 2024', 'August 2024', 'Septembrie 2024', 'Octombrie 2024',
      'Noiembrie 2024', 'Decembrie 2024'
    ]
  end

  def analiza_lunara
    set_month_and_year

    @facturi = Facturaproforma.where("EXTRACT(YEAR FROM data_platii) = ? AND EXTRACT(MONTH FROM data_platii) = ? AND status = ?", @anul, @month_number, "Achitata")
    @facturi_platite = @facturi.where.not(data_platii: nil)
    @total_plati_aygr = @facturi_platite.sum(:valoare_totala)

    @facturas_achitate = Factura.where("EXTRACT(YEAR FROM updated_at) = ? AND EXTRACT(MONTH FROM updated_at) = ? AND status = ?", @anul, @month_number, "Achitata")
    @total_plati_facturas = @facturas_achitate.sum(:valoare_totala)
  end

  def download_analiza_lunara
    set_month_and_year

    @facturi = Facturaproforma.where("EXTRACT(YEAR FROM data_platii) = ? AND EXTRACT(MONTH FROM data_platii) = ? AND status = ?", @anul, @month_number, "Achitata")
    @facturi_platite = @facturi.where.not(data_platii: nil)
    @total_plati_aygr = @facturi_platite.sum(:valoare_totala)

    @facturas_achitate = Factura.where("EXTRACT(YEAR FROM updated_at) = ? AND EXTRACT(MONTH FROM updated_at) = ? AND status = ?", @anul, @month_number, "Achitata")
    @total_plati_facturas = @facturas_achitate.sum(:valoare_totala)

    respond_to do |format|
      format.html
      format.pdf do
        html = render_to_string(
          template: 'facturaproformas/analiza_lunara', # Asigură-te că denumirea și calea sunt corecte
          locals: { facturi: @facturi_platite, total_plati_aygr: @total_plati_aygr, total_plati_facturas: @total_plati_facturas, selected_month: @selected_month },
          encoding: 'UTF8'
        )
        pdf = PDFKit.new(html).to_pdf
        filename = "Raport_Analiza_Lunara_#{@selected_month}.pdf"
        send_data pdf, filename: filename, type: 'application/pdf', disposition: 'attachment'
      end
    end
  end
  ###############
  def generare_facturi
    cods = ['cod214', 'cod215', 'cod216', 'cod217', 'cod218', 'cod219', 'cod220', 'cod221', 'cod222', 'cod223', 'cod224']

    @prod = Prod.where(cod: cods)
                .order(Arel.sql("CASE cod " + cods.map.with_index { |cod, index| "WHEN '#{cod}' THEN #{index}" }.join(' ') + " END"))
    
  end  
  # POST /facturaproformas/creareproforma
  #DESCRIERE metoda de mai jos: Daca userul nu are cont si este in tabela An32324 NU i se va face 
  #factura- nu se vor crea inregistrari in cele 3 tabele : Comanda, ComenziProd si Facturaproforma
  #daca in tabela An32324 pret == nil sau 0 nu se creaza inregistrari si deci nici factura
  #se creaza inregistrari in cele 3 tabele doar pt useri cu cont sa fie in An32324 cu pret>0
  #daca in An32324  la pret este trecut gr. va fi preluat cu 0 deci nu se va factura
  #AS VREA sa preaiau nume+prenume din ce pun userii pt ca acum preiau din An32324 dati de Nina (are doar nume)
  def creareproforma
    


    begin
      produs_id = params[:produs_id]
      @prod = Prod.find(produs_id)
  
      # Setăm datele în funcție de codul produsului
      case @prod.cod     
      # Adding a one-month gap after 'cod37', so cod214 starts from August
      when 'cod214'
        datacomenzii = Date.new(2024, 8, 31)
      when 'cod215'
        datacomenzii = Date.new(2024, 9, 25)
      when 'cod216'
        datacomenzii = Date.new(2024, 10, 31)
      when 'cod217'
        datacomenzii = Date.new(2024, 11, 30)
      when 'cod218'
        datacomenzii = Date.new(2024, 12, 31)
      when 'cod219'
        datacomenzii = Date.new(2025, 1, 31)
      when 'cod220'
        datacomenzii = Date.new(2025, 2, 28)
      when 'cod221'
        datacomenzii = Date.new(2025, 3, 31)
      when 'cod222'
        datacomenzii = Date.new(2025, 4, 30)
      when 'cod223'
        datacomenzii = Date.new(2025, 5, 31)
      when 'cod224'
        datacomenzii = Date.new(2025, 6, 30)
      else
        raise "Codul produsului nu este recunoscut"
      end
  
      datainceput = datacomenzii
      datasfarsit = datacomenzii + @prod.valabilitatezile.to_i.days
      data_emiterii = datacomenzii
  
      An32324.find_each do |an_entry|
        user = User.find_by(email: an_entry.email)
        next unless user # Sarim daca utilizatorul nu este găsit
  
        # Verifică prețul din tabela An32324
        pret = an_entry.pret
        next if pret.nil? || pret.to_f == 0.0 # Sarim dacă prețul este nul sau 0
  
        # Verifică dacă există deja o factură proforma pentru acest user și produs
        if Facturaproforma.exists?(user_id: user.id, prod_id: produs_id)
          puts "Există deja o factură proforma pentru utilizatorul #{user.id} și produsul #{produs_id}."
          next
        end
  
        ActiveRecord::Base.transaction do
          # Creează înregistrarea în tabela Comanda
          comanda = Comanda.create!(
            datacomenzii: datacomenzii,
            statecomanda1: 'Initiata',
            statecomanda2: 'Asteptare',
            stateplata1: 'Asteptare',
            stateplata2: 'Asteptare',
            stateplata3: 'Asteptare',
            user_id: user.id,
            emailcurrent: an_entry.email,
            telefon: an_entry.telefon,
            total: pret,
            plataprin: 'Asteptare',
            prodid: @prod.id,
            prodcod: @prod.cod
          )
  
          # Actualizează numărul comenzii
          numar_comanda = Comanda.maximum(:id).to_i #asta asigura ca id este la fel cu numar_comanda
          comanda.update!(numar: numar_comanda)
  
          # Creează înregistrarea în tabela ComenziProd
          ComenziProd.create!(
            comanda_id: comanda.id,
            prod_id: @prod.id,
            user_id: user.id,
            validat: "Initiata",
            datainceput: datainceput,
            datasfarsit: datasfarsit,
            cantitate: 1,
            pret_bucata: pret,
            pret_total: pret,
            obs: "fara"
          )
  
          ## Găsește datele de facturare
          df = DateFacturare.find_by(email: an_entry.email)
  
          # Setează valorile implicite dacă datele de facturare nu sunt găsite
          nume = an_entry.nume
          localitate = "Bucuresti"
  
          if df
            nume = df.nume.capitalize + ' ' + df.prenume.capitalize
            localitate = df.localitate
            nume_companie = df.numecompanie
            cui = df.cui
            tara = df.tara
            judet = df.judet
            strada = df.strada
            numar_adresa = df.numar
            cod_postal = df.codpostal
            altedate = df.altedate
            telefon = df.telefon
          else
            nume_companie = nil
            cui = nil
            tara = nil
            judet = nil
            strada = nil
            numar_adresa = nil
            cod_postal = nil
            altedate = nil
            telefon = an_entry.telefon
          end
  
          # Obține numărul de factură
          last_factura = Facturaproforma.maximum(:numar_factura).to_i
          numar_factura = last_factura == 0 ? 240001 : last_factura + 1
          numar_factura = numar_factura.to_s
  
          # Obține detaliile firmei
          firma = Firmeproforma.find_by(cod: 'cod1')
          raise ActiveRecord::RecordNotFound, "Firma nu a fost găsită" unless firma
  
          # Creează înregistrarea în tabela Facturaproforma
          Facturaproforma.create!(
            comanda_id: comanda.id,
            user_id: user.id,
            prod_id: @prod.id,
            numar_factura: numar_factura,
            numar_comanda: comanda.id,
            data_emiterii: data_emiterii,
            nume: nume,
            nume_companie: nume_companie,
            cui: cui,
            tara: tara,
            localitate: localitate,
            judet: judet,
            strada: strada,
            numar_adresa: numar_adresa,
            cod_postal: cod_postal,
            altedate: altedate,
            telefon: telefon,
            produs: @prod.nume,
            cantitate: 1,
            pret_unitar: pret,
            valoare_tva: firma.tva,
            valoare_totala: pret,
            cod_firma: firma.cod,
            status: "Proforma",
            serie_factura: firma.serie
          )
        end
      end
  
      flash[:success] = "Facturile proforma au fost create cu succes."
      redirect_to panouadmin_path # Înlocuiește cu calea corespunzătoare
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
      puts "Eroare: #{e.message}"
      flash[:error] = "A apărut o eroare: #{e.message}"
      redirect_to root_path # Înlocuiește cu calea corespunzătoare
    end
  end

  def not_in_users #lista userilor de an 3 care nu au cont
    listacanal3_emails = Listacanal3.pluck(:email)
    user_emails = User.pluck(:email)
    date_facturare = DateFacturare.pluck(:email)

    @emails_not_in_users = listacanal3_emails - user_emails
    @emails_useri_care_nu_au_completat = listacanal3_emails - date_facturare
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_facturaproforma
      @facturaproforma = Facturaproforma.find(params[:id])
    end

    ## Only allow a list of trusted parameters through.
    def facturaproforma_params
      params.require(:facturaproforma).permit(:comanda_id, :user_id, :prod_id, :numar_factura, :numar_comanda, :data_emiterii, :prenume, :nume, :nume_companie, :cui, :tara, :localitate, :judet, :strada, :numar_adresa, :cod_postal, :altedate, :telefon, :produs, :cantitate, :pret_unitar, :valoare_tva, :valoare_totala, :cod_firma, :status, :serie_factura, :plata_prin, :data_platii, :obs)
    end
    def set_user_admin
      if !current_user
        redirect_to root_path, alert: "Nu ai permisiunea de a accesa această pagină."
        return
      end  
      unless current_user.role == 1
        redirect_to root_path, alert: "Nu ai permisiunea de a accesa această pagină."
        return
      end
    end

    def preluare_date_furnizor(cod1)
      furnizor = Firmeproforma.find_by(cod: cod1)
      if furnizor
        @nume_institutie = furnizor.nume_institutie
        @cui = furnizor.cui
        @rc = furnizor.rc
        @adresa = furnizor.adresa
        @banca = furnizor.banca
        @cont = furnizor.cont
        @serie = furnizor.serie
        @nrinceput = furnizor.nrinceput
        @tva = furnizor.tva
        @cod = furnizor.cod
      else
        redirect_to root_path, alert: "Furnizorul cu codul specificat nu a fost găsit"
      end
    end
    def set_user
      @user = current_user # presupunând că current_user este disponibil
    end
    def reset_stripe_session
      session[:stripe_session_id] = nil
    end
    def set_stripe_key
      if Rails.env.development?
        @stripe_public_key = Rails.application.credentials.dig(:stripe, :development, :publishable_key)
        @stripe_secret_key = Rails.application.credentials.dig(:stripe, :development, :secret_key)
      elsif Rails.env.production?
        @stripe_public_key = Rails.application.credentials.dig(:stripe, :production, :publishable_key)
        @stripe_secret_key = Rails.application.credentials.dig(:stripe, :production, :secret_key)
      end
    end
    
    def set_month_and_year
      month_mapping = {
        'Ianuarie 2024' => 1,
        'Februarie 2024' => 2,
        'Martie 2024' => 3,
        'Aprilie 2024' => 4,
        'Mai 2024' => 5,
        'Iunie 2024' => 6,
        'Iulie 2024' => 7,
        'August 2024' => 8,
        'Septembrie 2024' => 9,
        'Octombrie 2024' => 10,
        'Noiembrie 2024' => 11,
        'Decembrie 2024' => 12
      }
      @selected_month = params[:month]
      @month_number = month_mapping[@selected_month]
      @anul = @selected_month.scan(/\d{4}/).first.to_i
    end
   
end
