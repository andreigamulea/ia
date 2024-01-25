class ContractesController < ApplicationController
  before_action :set_contracte, only: %i[ show edit update destroy ]
  before_action :set_contracte_useri, only: %i[vizualizeaza_contract destroy_contracte_useri]

  # GET /contractes or /contractes.json
  def voluntariat
  end  
  def voluntar
  end 
  def cerere_voluntar
  end   
  def gdpr
  end
  def fisa_postului
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
    @contractes = Contracte.all
    @contracte = Contracte.last
  end
  def semneaza_contract
    @contract=Contracte.first
    @nume_firma=@contract.nume_firma
    @sediu_firma=@contract.sediu_firma
    @cui_firma=@contract.cui_firma
    @reprezentant_firma=@contract.reprezentant_firma    
    @calitate_reprezentant=@contract.calitate_reprezentant
    @semnatura_admin = @contract.semnatura_admin if @contract
    @contracte_useri = ContracteUseri.new
  end  
  def contracte_all
    @contract=Contracte.first
    @reprezentant_firma=@contract.reprezentant_firma
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
  end

  # GET /contractes/new
  def new
    @contracte = Contracte.new
    #@contracte_useri = ContracteUseri.new
  end

  # GET /contractes/1/edit
  def edit
    @contracte = Contracte.find(params[:id])
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
      @contracte = Contracte.find(params[:id])
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
        :contor, 
        :textcontract,
        :nume_firma,
        :sediu_firma,
        :cont_bancar,
        :banca_firma,
        :cui_firma,
        :reprezentant_firma,
        :calitate_reprezentant,
        :semnatura_admin
      )
    end
    def contracte_useri_params
      params.require(:contracte_useri).permit(
        :nume_voluntar, 
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
        :judet_voluntar
      )
    end
    
    def valid_email?(email)
      email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
      !!(email =~ email_regex)
    end

    
end
