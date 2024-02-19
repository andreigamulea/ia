class ContractesController < ApplicationController
  before_action :set_contracte, only: %i[ show edit update destroy ]
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
    
  end  
  def voluntar
    unless session[:verificat]
      redirect_to voluntariat_path, alert: "Acces neautorizat."
    end
    @status1 = "required"
    @status2 = "required"
    @status3 = "required"
    @status4 = "required"
  end 
  def cerere_voluntar
    if session[:contract_id]
      @contract = Contracte.find_by(id: session[:contract_id])
      @gazda = @contract.nume_firma
      @adresa_firma = @contract.sediu_firma
      @email_admin = @contract.email
      @nume_admin = @contract.reprezentant_firma
    else
      redirect_to voluntariat_path, alert: "Acces neautorizat."
    end  
  end   
  def gdpr
    if session[:contract_id]
      @contract = Contracte.find_by(id: session[:contract_id])
      @gazda = @contract.nume_firma
      @adresa_firma = @contract.sediu_firma
      @email_admin = @contract.email
      @nume_admin = @contract.reprezentant_firma
    else
      redirect_to voluntariat_path, alert: "Acces neautorizat."
    end  

  end
  def fisa_postului
    if session[:contract_id]
      @contract = Contracte.find_by(id: session[:contract_id])
      @gazda = @contract.nume_firma
      @adresa_firma = @contract.sediu_firma
      @sarcini = @contract.sarcini_voluntar.split(';').map(&:strip) #atentie sarcinile trebuiesc obligatoriu separate prin ; in tabela postges

      
    else
      redirect_to voluntariat_path, alert: "Acces neautorizat."
    end  
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
    #@contract = Contracte.find_by(id: session[:contract_id])
    @contract = Contracte.first
    @nume_firma=@contract.nume_firma
    @sediu_firma=@contract.sediu_firma
    @cui_firma=@contract.cui_firma
    @reprezentant_firma=@contract.reprezentant_firma    
    @calitate_reprezentant=@contract.calitate_reprezentant
    @semnatura_admin = @contract.semnatura_admin if @contract
    @contracte_useri = ContracteUseri.new
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
    @nume_firma = @contract&.nume_firma
    @email_firma = @contract&.email
    @tip_contract = @contract&.tip
    @denumire_contract = @contract&.denumire
    @serie_contract = @contract&.cod_contract
    @start_contract = @contract&.contor_start   
    @sediu_firma = @contract&.sediu_firma
    @cui_firma = @contract&.cui_firma
    @cont_bancar = @contract&.cont_bancar
    @banca_firma = @contract&.banca_firma
    @reprezentant_firma = @contract&.reprezentant_firma    
    @calitate_reprezentant = @contract&.calitate_reprezentant    

    @denumire_post_voluntar = @contract&.denumire_post
    @coordonator_voluntar = @contract&.subordonare
    @locul_desfasurarii_activitatii_voluntar = @contract&.locul_desfasurarii
    @departament = @contract&.departament
    @relatii_functionale_voluntar = @contract&.relatii_functionale 
    @sarcini_voluntar = @contract&.sarcini_voluntar
    @valabilitate_luni = @contract&.valabilitate_luni

  end

  # GET /contractes/new
  def new
    @contracte = Contracte.new
    #@contracte_useri = ContracteUseri.new
  end

  # GET /contractes/1/edit
  def edit
    @contract = Contracte.find(params[:id])
    @nume_firma = @contract&.nume_firma
    @email_firma = @contract&.email
    @tip_contract = @contract&.tip
    @denumire_contract = @contract&.denumire
    @serie_contract = @contract&.cod_contract
    @start_contract = @contract&.contor_start   
    @sediu_firma = @contract&.sediu_firma
    @cui_firma = @contract&.cui_firma
    @cont_bancar = @contract&.cont_bancar
    @banca_firma = @contract&.banca_firma
    @reprezentant_firma = @contract&.reprezentant_firma    
    @calitate_reprezentant = @contract&.calitate_reprezentant    

    @denumire_post_voluntar = @contract&.denumire_post
    @coordonator_voluntar = @contract&.subordonare
    @locul_desfasurarii_activitatii_voluntar = @contract&.locul_desfasurarii
    @departament = @contract&.departament
    @relatii_functionale_voluntar = @contract&.relatii_functionale 
    @sarcini_voluntar = @contract&.sarcini_voluntar
    @valabilitate_luni = @contract&.valabilitate_luni

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

def update_contracte_useri
  @contracte_useri = ContracteUseri.find(params[:id])
  if @contracte_useri.update(contracte_useri_params)
    puts("s-a salvat")
    redirect_to contracte_all_path, notice: 'ContracteUseri was successfully updated.'
    
  else
    puts("nu s-a salvat")
    render :edit_contracte_useri
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
      @contract = Contracte.find(params[:id])
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
        :email, #la GDPR trebuie sa completeze o adresa de email care poate fi diferita de cea a userului
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
        :status
      )
    end
    
    def valid_email?(email)
      email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
      !!(email =~ email_regex)
    end

    
end
