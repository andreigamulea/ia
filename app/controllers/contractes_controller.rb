class ContractesController < ApplicationController
  before_action :set_contracte, only: %i[ show edit update destroy ]

  # GET /contractes or /contractes.json
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
  def vizualizeaza_contract    
    @contract = Contracte.first
    @contracte_useri = ContracteUseri.first
  
    @nume_firma = @contract&.nume_firma
    @sediu_firma = @contract&.sediu_firma
    @cui_firma = @contract&.cui_firma
    @reprezentant_firma = @contract&.reprezentant_firma    
    @calitate_reprezentant = @contract&.calitate_reprezentant
    @semnatura_admin = @contract&.semnatura_admin

    @nume_voluntar = @contracte_useri&.nume_voluntar
    @domiciliu_voluntar_voluntar = @contracte_useri&.domiciliu_voluntar
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
  end

  # PATCH/PUT /contractes/1 or /contractes/1.json
  def update
   
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
  end

  # DELETE /contractes/1 or /contractes/1.json
  def destroy
    @contracte.destroy

    respond_to do |format|
      format.html { redirect_to contractes_url, notice: "Contracte was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contracte
      @contracte = Contracte.find(params[:id])
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
      params.require(:contracte_useri).permit(:nume_voluntar, :domiciliu_voluntar, :ci_voluntar, :eliberat_de, :eliberat_data, :contracte_id, :semnatura_voluntar)
    end 
    
end
