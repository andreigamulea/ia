class ContractesController < ApplicationController
  before_action :set_contracte, only: %i[ show edit update destroy]
  before_action :set_contract, only: %i[ cerere_voluntar1 gdpr1 semneaza_contract1 fisa_postului1]
  before_action :set_contracte_useri, only: %i[vizualizeaza_contract destroy_contracte_useri]

  # GET /contractes or /contractes.json
  def verifica_cod
    prefix = params[:code_part1]
    cod = params[:code_part2]
    contract = Contracte.find_by(cod_contract: prefix, cui_firma: cod)
    session[:verificat] = false # Inițializează sesiunea ca neverificată
  
    if contract # Verifică dacă contractul există
      session[:verificat] = true # Setează sesiunea ca verificată
      session[:contract_id] = contract.id # Actualizează ID-ul contractului în sesiune
  
      redirect_to voluntar_path
    else
      redirect_to voluntariat_path, alert: "Nu s-a găsit nicio înregistrare corespunzătoare."
    end
  end
  
  
  def voluntariat   
    unless current_user
      redirect_to new_user_session_with_return_path('voluntariat'), alert: "Trebuie să te autentifici pentru a accesa această pagină."
      return
    end  
  end  
  def voluntar
    @contract = Contracte.find_by(id: session[:contract_id])
    unless @contract
      # Dacă @contract este nil, facem redirect la o pagină dorită cu un mesaj
      redirect_to voluntariat_path, alert: "Contractul nu a fost găsit."
      return # Opriți executarea metodei aici
    end
    @contracte_useri = @contract.contracte_useris.find_or_initialize_by(contracte_id: @contract.id, user_id: @current_user.id)
    # Stocăm ID-ul contractului în sesiune
    session[:contract_id] = @contract.id if @contract
    # Dacă @contracte_useri a fost salvat sau există deja în baza de date, stocăm ID-ul său în sesiune
    session[:contracte_useri_id] = @contracte_useri.id if @contracte_useri.persisted?
    unless session[:verificat]
      redirect_to voluntariat_path, alert: "Acces neautorizat."
    end
    puts("@contract din voluntar este: #{@contract.id}")
      puts("@contracte_useri din voluntar: #{@contracte_useri.id}")
    if @contracte_useri.persisted?
      @status1 = "pending" #folosesc app\helpers\contractes_helper.rb pt a gestiona culorile
    else  
      @status1 = "required"
    end  
    if @contracte_useri.semnatura1==nil
      @status2 = "required"
    else
      @status2 = "pending"
    end  
    if @contracte_useri.semnatura2==nil
      @status3 = "required"
    else
      @status3 = "pending"
    end  
    if @contracte_useri.semnatura3==nil
      @status4 = "required"
    else
      @status4 = "pending"
    end  
  end 
  def cerere_voluntar
    puts("aaaaaaa")
    if session[:contract_id]
      puts("ID Contract: #{session[:contract_id]}")
      @contract = Contracte.find_by(id: session[:contract_id])
      @contracte_useri = @contract.contracte_useris.find_or_initialize_by(contracte_id: @contract.id, user_id: @current_user.id)
      puts("@contract din cerere_voluntar este: #{@contract.id}")
      puts("@contracte_useri din cerere_voluntar: #{@contracte_useri.id}")
      @show_submit_button = true
    else
      redirect_to voluntariat_path, alert: "Acces neautorizat."
    end  
  end   
  def cerere_voluntar1
    puts("da000000000")
    if params[:contract_id]
      puts("da1111111111")
      @contract = Contracte.find_by(id: params[:contract_id])
      @contracte_useri = ContracteUseri.new
      puts("da2222222222")
      @gazda = @contract.nume_firma
      
      @adresa_firma = @contract.sediu_firma
      @email_admin = @contract.email
      @nume_admin = @contract.reprezentant_firma
      @show_submit_button = false
      @semnatura_admin = @contract.semnatura_admin if @contract.respond_to?(:semnatura_admin)
        @cui_firma = @contract.cui_firma      
        @calitate_reprezentant = @contract.calitate_reprezentant     
        @durata_contract = @contract.valabilitate_luni

        
      
    else
      redirect_to voluntariat_path, alert: "Acces neautorizat."
    end  
    render 'contractes/cerere_voluntar'
  end   
  
  def gdpr
    if session[:contract_id] 
      puts("@contract din semneaza_contract este: #{session[:contract_id]}")
      @contract = Contracte.find_by(id: session[:contract_id])
      @contracte_useri = @contract.contracte_useris.find_by(user_id: @current_user.id)
      if !@contracte_useri || @contracte_useri.semnatura_voluntar==nil
        redirect_to voluntar_path, alert: "Acces neautorizat."
        return
      end  
      set_shared_data(@contract, @contracte_useri)
    else
      # Gestionarea cazurilor în care contractul sau contracte_useri nu sunt găsite
      redirect_to voluntar_path, alert: "Contractul sau datele de utilizator asociate nu au fost găsite."
    end
  end
  
  
  
  def gdpr1  #pentru contractori sa vada orice gdpr al oricarui voluntar
    puts("aaaaaaaaaaaaaaaaa")
    puts("Contractul id este: #{params[:contract_id]}")
    if params[:contract_id]
      @contract = Contracte.find_by(id: params[:contract_id])
      @contracte_useri = ContracteUseri.new
      @gazda = @contract.nume_firma
      @adresa_firma = @contract.sediu_firma
      @email_admin = @contract.email
      @nume_admin = @contract.reprezentant_firma
      @show_submit_button = false
    else
      redirect_to voluntariat_path, alert: "Acces neautorizat."
    end  
    render 'contractes/gdpr'
  end
  def fisa_postului
    if session[:contract_id] 
      puts("@contract din semneaza_contract este: #{session[:contract_id]}")
      @contract = Contracte.find_by(id: session[:contract_id])
      @contracte_useri = @contract.contracte_useris.find_by(user_id: @current_user.id)

      
      if !@contracte_useri || @contracte_useri.semnatura2==nil
        redirect_to voluntar_path, alert: "Acces neautorizat."
        return
      end  
      set_shared_data(@contract, @contracte_useri)
    else
      redirect_to voluntariat_path, alert: "Acces neautorizat."
    end  
    
  end    
  def fisa_postului1
    if params[:contract_id]
      @contracte = Contracte.find_by(id: params[:contract_id])
      @contracte_useri = ContracteUseri.new
       #atentie sarcinile trebuiesc obligatoriu separate prin ; in tabela postges
#####
    @nume_firma = @contracte&.nume_firma
    @email_firma = @contracte&.email
    @tip_contract = @contracte&.tip
    @denumire_contract = @contracte&.denumire
    @serie_contract = @contracte&.cod_contract
    @start_contract = @contracte&.contor_start   
    @sediu_firma = @contracte&.sediu_firma
    @cui_firma = @contracte&.cui_firma
    @cont_bancar = @contracte&.cont_bancar
    @banca_firma = @contracte&.banca_firma
    @reprezentant_firma = @contracte&.reprezentant_firma    
    @calitate_reprezentant = @contracte&.calitate_reprezentant    
    @semnatura_admin = @contracte.semnatura_admin if @contracte
    @denumire_post_voluntar = @contracte&.denumire_post
    @coordonator_voluntar = @contracte&.subordonare
    @locul_desfasurarii_activitatii_voluntar = @contracte&.locul_desfasurarii
    @departament = @contracte&.departament
    @relatii_functionale_voluntar = @contracte&.relatii_functionale 
    
    @sarcini = @contracte.sarcini_voluntar.split(';').map(&:strip)
    @valabilitate_luni = @contracte&.valabilitate_luni
    @show_submit_button = false
    else
      redirect_to voluntariat_path, alert: "Acces neautorizat."
    end  
    render 'contractes/fisa_postului'
  end    
  def preluare_emailuri_din_text # aceasta metoda va fi adaptata. Contractorii vor pune in formular mailurile care vor semna contracte
    text = params[:text] || "Emailul meu este: luminita.trapcea@gmail.com olga@magicon.co.uk, braferdes@gmail.com;  "
    potential_email_regex = /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b/
    potential_emails = text.scan(potential_email_regex)
    valid_emails = potential_emails.select { |email| valid_email?(email) }

    respond_to do |format|
      format.html { @emails = valid_emails }
      format.json { render json: valid_emails }
    end
    puts valid_emails
  end
  
  def index
    
    unless current_user
      redirect_to new_user_session_with_return_path('voluntariat'), alert: "Trebuie să te autentifici pentru a accesa această pagină."
      return
    end  
    puts("da3")
    @prod = Prod.find_by(curslegatura: 'voluntari', status: 'activ')
    @contractes = Contracte.where(user_id: current_user.id)
    @nr_contractes = @contractes.count
    puts("@nr_contractes este: #{@nr_contractes}")
    #@contracte = Contracte.last
    produs_dorit = Prod.find_by(cod: 'cod111') #voluntari 5.8 lei/set
    # Verifică dacă produsul a fost găsit pentru a evita erori în pasul următor
    if produs_dorit
      # Acum, găsește toate comenziProd care corespund userului curent și produsului dorit, care sunt și marcate ca 'Finalizata'
      comenzi_finalizate = ComenziProd.where(user_id: current_user.id, prod_id: produs_dorit.id, validat: 'Finalizata')

      # Calculează suma cantităților pentru toate comenziProd găsite
      @nr_total_contracte_achizitionate = comenzi_finalizate.sum(:cantitate)
    else
      # Dacă produsul dorit nu există, setează numărul total de contracte achiziționate pe 0
      @nr_total_contracte_achizitionate = 0
    end
    puts("numarul: #{@nr_total_contracte_achizitionate}")
    # Numără ContracteUseris pentru contractele userului curent
    @numar_contracte_useris = ContracteUseri.joins(:contracte).where(contractes: { user_id: current_user.id }).count
    puts("numar contracte consumate: #{@numar_contracte_useris}")
    @contracte_useri = ContracteUseri.where(contracte_id: current_user.contractes.pluck(:id)) 
    
  end
  def semneaza_contract
    #contracte_useri.validare_semnatura_contract = true
   #####################
   if session[:contract_id] 
    puts("@contract din semneaza_contract este: #{session[:contract_id]}")
    @contract = Contracte.find_by(id: session[:contract_id])
    @contracte_useri = @contract.contracte_useris.find_by(user_id: @current_user.id)
    if !@contracte_useri || @contracte_useri.semnatura1==nil
      redirect_to voluntar_path, alert: "Acces neautorizat."
      return
    end  
    set_shared_data(@contract, @contracte_useri)
    # Verificăm dacă am găsit contractul
   
  else
    redirect_to voluntar_path, alert: "Acces neautorizat."
  end

   #####################
    
    
  end  
  def semneaza_contract1
    
    @nume_firma=@contract.nume_firma
    @sediu_firma=@contract.sediu_firma
    @cui_firma=@contract.cui_firma
    @reprezentant_firma=@contract.reprezentant_firma    
    @calitate_reprezentant=@contract.calitate_reprezentant
    @semnatura_admin = @contract.semnatura_admin if @contract
    @durata_contract = @contract.valabilitate_luni
    @contracte_useri = ContracteUseri.new
    @show_submit_button = false
    render 'contractes/semneaza_contract'
  end  
  def contracte_all
    @prods = Prod.where(curslegatura: 'documente', status: 'activ')
    @contracte_useri = ContracteUseri.all
  end  
  def vizualizeaza_contract    
    @contract = Contracte.first
    
  
    @nume_firma = @contract&.nume_firma
    @sediu_firma = @contract&.sediu_firma
    @cui_firma = @contract&.cui_firma
    @reprezentant_firma = @contract&.reprezentant_firma    
    @calitate_reprezentant = @contract&.calitate_reprezentant
    @semnatura_admin = @contract&.semnatura_admin

    @nume_voluntar = @contracte_useri&.nume_voluntar    
    @localitate_voluntar = @contracte_useri&.localitate_voluntar
    @strada_voluntar = @contracte_useri&.strada_voluntar
    @numarstrada_voluntar = @contracte_useri&.numarstrada_voluntar
    @bloc_voluntar = @contracte_useri&.bloc_voluntar
    @judet_voluntar = @contracte_useri&.judet_voluntar
    


    @ci_voluntar = @contracte_useri&.ci_voluntar
    @eliberat_de = @contracte_useri&.eliberat_de
    @eliberat_data = @contracte_useri&.eliberat_data
    @semnatura_voluntar = @contracte_useri&.semnatura_voluntar

  end
  

  # GET /contractes/1 or /contractes/1.json
  def show
    @nume_firma = @contracte&.nume_firma
    @email_firma = @contracte&.email
    @tip_contract = @contracte&.tip
    @denumire_contract = @contracte&.denumire
    @serie_contract = @contracte&.cod_contract
    @start_contract = @contracte&.contor_start   
    @sediu_firma = @contracte&.sediu_firma
    @cui_firma = @contracte&.cui_firma
    @cont_bancar = @contracte&.cont_bancar
    @banca_firma = @contracte&.banca_firma
    @reprezentant_firma = @contracte&.reprezentant_firma    
    @calitate_reprezentant = @contracte&.calitate_reprezentant    
  
    @denumire_post_voluntar = @contracte&.denumire_post
    @coordonator_voluntar = @contracte&.subordonare
    @locul_desfasurarii_activitatii_voluntar = @contracte&.locul_desfasurarii
    @departament = @contracte&.departament
    @relatii_functionale_voluntar = @contracte&.relatii_functionale 
    @sarcini_voluntar = @contracte&.sarcini_voluntar
    @valabilitate_luni = @contracte&.valabilitate_luni
  end
  

  # GET /contractes/new
  def new
    @contracte = Contracte.new
  end

  # GET /contractes/1/edit
  def edit
    @nume_firma = @contracte&.nume_firma
    @email_firma = @contracte&.email
    @tip_contract = @contracte&.tip
    @denumire_contract = @contracte&.denumire
    @serie_contract = @contracte&.cod_contract
    @start_contract = @contracte&.contor_start   
    @sediu_firma = @contracte&.sediu_firma
    @cui_firma = @contracte&.cui_firma
    @cont_bancar = @contracte&.cont_bancar
    @banca_firma = @contracte&.banca_firma
    @reprezentant_firma = @contracte&.reprezentant_firma    
    @calitate_reprezentant = @contracte&.calitate_reprezentant    
  
    @denumire_post_voluntar = @contracte&.denumire_post
    @coordonator_voluntar = @contracte&.subordonare
    @locul_desfasurarii_activitatii_voluntar = @contracte&.locul_desfasurarii
    @departament = @contracte&.departament
    @relatii_functionale_voluntar = @contracte&.relatii_functionale 
    @sarcini_voluntar = @contracte&.sarcini_voluntar
    @valabilitate_luni = @contracte&.valabilitate_luni
  end
  

  # POST /contractes or /contractes.json
  def create
    if params[:contracte_useri] && params[:contracte_useri][:save_type] == "contracte_useri"
      puts('am intrat unde trebuie')
      # Logica pentru salvarea unui ContracteUseri
      @contracte_useri = ContracteUseri.new(contracte_useri_params)
      
      
      puts('a trecut de contracte_useri_params')
      if @contracte_useri.save
        redirect_to root_path, notice: 'Contracte Useri a fost salvat cu succes.'
      else
        puts('nu s-a salvat')
        puts 'Erori:', @contracte_useri.errors.full_messages
        render :semneaza_contract

      end
    else

    
    @contracte = Contracte.new(contracte_params)

    respond_to do |format|
      if @contracte.save
        format.html { redirect_to contracte_url(@contracte), notice: "Contracte was successfully created." }
        format.json { render :show, status: :created, location: @contracte }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @contracte.errors, status: :unprocessable_entity }
      end
    end
  end end

  # PATCH/PUT /contractes/1 or /contractes/1.json
  def update
    @reprezentant_firma=@contracte.reprezentant_firma
    @contracte = Contracte.find(params[:id])
    respond_to do |format|
      if @contracte.update(contracte_params)
        format.html { redirect_to contracte_url(@contracte), notice: "Contracte was successfully updated." }
        format.json { render :show, status: :ok, location: @contracte }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @contracte.errors, status: :unprocessable_entity }
      end
    end
  end
  

  # DELETE /contractes/1 or /contractes/1.json
  def destroy
    @contracte.destroy

    respond_to do |format|
      format.html { redirect_to contractes_url, notice: "Contracte was successfully destroyed." }
      format.json { head :no_content }
    end
  end
##
# Acțiuni pentru ContracteUseri

def view_contracte_useri
  @contracte_useri = ContracteUseri.find(params[:id])
  # Logica pentru afișarea unui ContracteUseri
end

def edit_contracte_useri
  @contract = Contracte.first
    
  
  @nume_firma = @contract&.nume_firma
  @sediu_firma = @contract&.sediu_firma
  @cui_firma = @contract&.cui_firma
  @reprezentant_firma = @contract&.reprezentant_firma    
  @calitate_reprezentant = @contract&.calitate_reprezentant
  @semnatura_admin = @contract&.semnatura_admin

  @contracte_useri = ContracteUseri.find(params[:id])
  
end

def create_or_update_contracte_useri  #metoda este apelata cand se creaza/updateaza cerere_voluntar (este primul document)
  # Preia parametrii necesari pentru identificarea sau crearea înregistrării
  contracte_id = params[:contracte_useri][:contracte_id]
  user_id = params[:contracte_useri][:user_id]
  @contract = Contracte.find_by(id: params[:contract_id])
  @contracte_useri = ContracteUseri.find_or_initialize_by(contracte_id: contracte_id, user_id: user_id)
  @show_submit_button = true
  puts("@contract este: #{@contract.id}")
  puts("@contracte_useri: #{@contracte_useri.id}")
  # Caută o înregistrare existentă sau inițializează una nouă bazată pe contracte_id ȘI user_id
  
  puts("treceeeeee")
  ## Logica de procesare bazată pe starea înregistrării (nouă sau existentă)
  if @contracte_useri.new_record?
    # Dacă înregistrarea este nouă, încearcă să creezi
    if @contracte_useri.update(contracte_useri_params)
      #redirect_to contracte_all_path, notice: 'ContracteUseri was successfully created/updated.'
      redirect_to voluntar_path, notice: 'ContracteUseri was successfully created/updated.'
    else
      puts("blabla")
      flash.now[:alert] = 'Au fost întâmpinate erori.' # opțional, dacă vrei să adaugi un mesaj flash
      render :cerere_voluntar, status: :unprocessable_entity
    end
  else
    # Dacă înregistrarea există, încearcă să actualizezi
    if @contracte_useri.update(contracte_useri_params)
      #redirect_to contracte_all_path, notice: 'ContracteUseri was successfully updated.'
      redirect_to voluntar_path, notice: 'ContracteUseri was successfully updated.'
    else
      # Re-renderizează view-ul pentru a afișa erorile
      render :cerere_voluntar, status: :unprocessable_entity
    end
  end
  
end

def salveaza_gdpr

  @contract = Contracte.find(params[:id]) # Găsește contractul specific folosind ID-ul din URL
  @contracte_useri = @contract.contracte_useris.find_by(user_id: current_user.id) # Găsește recordul specificul utilizatorului curent
  @contracte_useri.validare_gdpr = true
  @show_submit_button = true
  puts("@contract din salveaza_gdpr este: #{@contract.id}")
  puts("@contracte_useri din salveaza_gdpr: #{@contracte_useri.id}")
  puts("Semnatura1 din salveaza_gdpr: #{params[:contracte_useri][:semnatura1]}")
  puts("pana aici")
  if @contracte_useri.update(semnatura1: params[:contracte_useri][:semnatura1]) # Actualizează campul `semnatura1` cu valoarea primită
    # Procesare după actualizare cu succes
    redirect_to voluntar_path, notice: "Semnătura a fost salvată cu succes."
  else
    set_shared_data(@contract, @contracte_useri)
    
    # Procesare în caz de eroare
    flash.now[:alert] = "Eroare la salvarea semnăturii."
    render :gdpr, status: :unprocessable_entity
    #redirect_to gdpr_path, notice: "Semnătura a fost salvată cu succes."
  end
end

def salveaza_contract
  @contract = Contracte.find(params[:id]) # Găsește contractul specific folosind ID-ul din URL
  @contracte_useri = @contract.contracte_useris.find_by(user_id: current_user.id) # Găsește recordul specific utilizatorului curent
  @contracte_useri.validare_semnatura_contract = true
  @show_submit_button = true
  puts("@contract din salveaza_contract este: #{@contract.id}")
  puts("@contracte_useri salveaza_contract: #{@contracte_useri.id}")
  puts("semnatura2 in salveaza_contract este: #{@contracte_useri.semnatura2}")
  if @contracte_useri.update(contracte_useri_params) # Actualizează campul `semnatura1` cu valoarea primită
    # Procesare după actualizare cu succes
    redirect_to voluntar_path, notice: "Semnătura a fost salvată cu succes."
  else
    puts("saluuuuuuuuut")
    # Procesare în caz de eroare
    set_shared_data(@contract, @contracte_useri)
    render :semneaza_contract,  status: :unprocessable_entity
  end
end

def salveaza_fisa_postului
  @contract = Contracte.find(params[:id]) # Găsește contractul specific folosind ID-ul din URL
  @contracte_useri = @contract.contracte_useris.find_by(user_id: current_user.id) # Găsește recordul specific utilizatorului curent
  
  
  @contracte_useri.validare_semnatura3 = true
  @show_submit_button = true
  puts("@contract din salveaza_fisa_postului este: #{@contract.id}")
  puts("@contracte_useri ssalveaza_fisa_postului: #{@contracte_useri.id}")
  puts("semnatura3 in salveaza_fisa_postului este: #{@contracte_useri.semnatura3}")
  
 
  if @contracte_useri.update(contracte_useri_params) # Actualizează campul `semnatura1` cu valoarea primită
    # Procesare după actualizare cu succes
    redirect_to voluntar_path, notice: "Semnătura a fost salvată cu succes."
  else
    puts("saluuuuuuuuut")
    # Procesare în caz de eroare
    set_shared_data(@contract, @contracte_useri)
    render :fisa_postului,  status: :unprocessable_entity
  end
end



def destroy_contracte_useri
  puts("salut")
  @contracte_useri.destroy
  redirect_to contracte_all_path, notice: 'ContracteUseri was successfully destroyed.'
end

def show_pdf
  

  @contracte_useri = ContracteUseri.find(params[:id])
  @contract = Contracte.first
    
  
    @nume_firma = @contract&.nume_firma
    @sediu_firma = @contract&.sediu_firma
    @cui_firma = @contract&.cui_firma
    @reprezentant_firma = @contract&.reprezentant_firma    
    @calitate_reprezentant = @contract&.calitate_reprezentant
    @semnatura_admin = @contract&.semnatura_admin

    @nume_voluntar = @contracte_useri&.nume_voluntar    
    @localitate_voluntar = @contracte_useri&.localitate_voluntar
    @strada_voluntar = @contracte_useri&.strada_voluntar
    @numarstrada_voluntar = @contracte_useri&.numarstrada_voluntar
    @bloc_voluntar = @contracte_useri&.bloc_voluntar
    @judet_voluntar = @contracte_useri&.judet_voluntar
    


    @ci_voluntar = @contracte_useri&.ci_voluntar
    @eliberat_de = @contracte_useri&.eliberat_de
    @eliberat_data = @contracte_useri&.eliberat_data
    @semnatura_voluntar = @contracte_useri&.semnatura_voluntar

  #unless @contract.user_id == @user.id || @user.role == 1
   # redirect_to root_path, alert: "Nu aveți permisiunea de a vizualiza această factură"
    #return
  #end

  respond_to do |format|
    format.html
    format.pdf do
      html = render_to_string(
      template: 'contractes/show_pdf',
      locals: { contract: @contracte_useri },
      encoding: 'UTF8'
    )
        # Setează opțiunile pentru PDFKit, inclusiv dimensiunea paginii la A4
    options = {
      page_size: 'A4',
      margin_top: '10mm',
      margin_right: '10mm',
      margin_bottom: '10mm',
      margin_left: '10mm',
      encoding: 'UTF8'
    }

    pdf = PDFKit.new(html, options).to_pdf
      send_data pdf, filename: "Contract_#{@contracte_useri.id}_din_#{@contracte_useri.created_at.strftime('%d.%m.%Y')}.pdf",
        type: 'application/pdf',
        disposition: 'attachment'
    end
  end
end
 
##



  private
    # Strong parameters pentru ContracteUseri
    
    # Use callbacks to share common setup or constraints between actions.
    def set_contracte
      puts("111")
      @contracte = Contracte.find(params[:id])
      puts("Contract nr : #{@contracte.id}")
      puts("222")
    end
    def set_contract
      puts("333")
      @contract = Contracte.find(params[:contract_id])
      puts("Contract nr : #{@contract.id}")
      puts("444")
    end
    def set_contracte_useri
      @contracte_useri = ContracteUseri.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def contracte_params
      params.require(:contracte).permit(
        :user_id, 
        :email, 
        :tip, 
        :denumire, 
        :cod_contract,
        :contor, 
        :textcontract,
        :nume_firma,
        :sediu_firma,
        :cont_bancar,
        :banca_firma,
        :cui_firma,
        :denumire_post,
        :locul_desfasurarii,
        :departament,
        :subordonare,
        :relatii_functionale,
        :reprezentant_firma,
        :calitate_reprezentant,
        :semnatura_admin,
        :contor_start,
        :valabilitate_luni,
        :sarcini_voluntar
      )
    end
    def contracte_useri_params
      params.require(:contracte_useri).permit(
        :nume_voluntar, 
        :prenume,
        :telefon_voluntar,
        :email, # La GDPR trebuie să completeze o adresă de email care poate fi diferită de cea a userului
        :domiciliu_voluntar, 
        :ci_voluntar, 
        :eliberat_de, 
        :eliberat_data, 
        :contracte_id, 
        :semnatura_voluntar,
        :localitate_voluntar, 
        :strada_voluntar, 
        :numarstrada_voluntar, 
        :bloc_voluntar, 
        :judet_voluntar,
        :cod_contract,
        :nr_contract_referinta,
        :status,
        :perioada_contract,
        :data_inceperii,
        :coordonator_v,
        :semnatura_administrator,
        # Adăugăm câmpurile lipsă identificate
        :user_id,
        :idcontractor,
        :contract_content,
        :signature_data,
        :semnatura1,
        :semnatura2,
        :semnatura3,
        :semnatura4,
        :expira_la
      )
    end
    
    
    def valid_email?(email)
      email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
      !!(email =~ email_regex)
    end
    def set_shared_data(contract, contracte_useri)
      if contract && contracte_useri
        # Setări generale pentru contract
        @gazda = contract.nume_firma
        @adresa_firma = contract.sediu_firma
        @email_admin = contract.email
        @nume_admin = contract.reprezentant_firma
        @show_submit_button = true
        
        # Setări specifice pentru contracte_useri
        @nume_voluntar = "#{contracte_useri.nume_voluntar} #{contracte_useri.prenume}"
        @domiciliu = [
          contracte_useri.localitate_voluntar,
          contracte_useri.strada_voluntar,
          "nr. #{contracte_useri.numarstrada_voluntar}",
          ("Bloc #{contracte_useri.bloc_voluntar}" if contracte_useri.bloc_voluntar.present?),
          contracte_useri.judet_voluntar
        ].compact.join(", ")
        
        # Alte setări necesare, cum ar fi semnătura voluntarului/adminului, dacă este necesar
        @semnatura_voluntar = contracte_useri.semnatura2 if contracte_useri.respond_to?(:semnatura2)
        @semnatura_admin = contract.semnatura_admin if contract.respond_to?(:semnatura_admin)
        @cui_firma = @contract.cui_firma      
        @calitate_reprezentant = @contract.calitate_reprezentant     
        @durata_contract = @contract.valabilitate_luni

        @tip_contract = @contract&.tip
        @denumire_contract = @contract&.denumire
        @serie_contract = @contract&.cod_contract
        @start_contract = @contract&.contor_start       
        @cont_bancar = @contract&.cont_bancar
        @banca_firma = @contract&.banca_firma       
        @calitate_reprezentant = @contract&.calitate_reprezentant        
        @denumire_post_voluntar = @contract&.denumire_post
        @coordonator_voluntar = @contract&.subordonare
        @locul_desfasurarii_activitatii_voluntar = @contract&.locul_desfasurarii
        @departament = @contract&.departament
        @relatii_functionale_voluntar = @contract&.relatii_functionale     
        @sarcini = @contract.sarcini_voluntar.split(';').map(&:strip)
        @expira_la = Date.today + @contract.valabilitate_luni.months
        @cod_contract = @contract.cod_contract
        @nr_contract_referinta = ContracteUseri.maximum(:nr_contract_referinta).to_i + 1
        @status = "Activ"
        @coordonator_v = @contract&.subordonare
        @data_inceperii = Date.today
        @semnatura_administrator = @contract&.semnatura_admin
      else
        # Gestionarea cazurilor în care contractul sau contracte_useri nu sunt găsite
        redirect_to voluntariat_path, alert: "Nu au fost găsite date pentru configurarea GDPR sau semnătura contractului."
      end
    end
    
    
    
      
    
   
    
    
    
    
    
    
end
