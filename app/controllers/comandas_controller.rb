class ComandasController < ApplicationController
  before_action :set_comanda, only: %i[ show edit update destroy ]
  before_action :set_user_admin, only: %i[index edit show new destroy select_comanda_id edit_comenziprod update_comenziprod select_edit_comenziprod index11 edit11 new11]

  before_action :set_comenzi_prod1, only: [:edit11, :update11, :destroy11] #pt tabela ComenziProd1

  # GET /comandas or /comandas.json
  def index
    @comandas = Comanda.all.order(id: :desc)
  end
  
  def select_comanda_id
    # Aici, nu avem nevoie de niciun cod în special, doar să renderizăm vizualizarea
  end
  def edit_comenziprod
    @comenziprod = ComenziProd.find_by(comanda_id: params[:comanda_id])
    unless @comenziprod
      redirect_to root_path, alert: 'ComenziProd nu a fost găsit!'
    end
end

  
def update_comenziprod
  
  @comenziprod = ComenziProd.find_by(comanda_id: params[:id])
  puts("iata id-ul: #{@comenziprod.id}")
  if @comenziprod.update(comenziprod_params)
    redirect_to root_path, notice: 'ComenziProd a fost actualizat cu succes.'
  else
    render :edit
  end
  

  # restul codului...
end



  def select_edit_comenziprod
    if params[:comanda_id].present?
      redirect_to edit_comenziprod_path(comanda_id: params[:comanda_id])
    else
      # poți adăuga un flash de alertă sau altă logică
      redirect_to select_comanda_id_path, alert: "ID-ul comenzii nu este valid."
    end
  end
  


  # GET /comandas/1 or /comandas/1.json
  def show
  end

  # GET /comandas/new
  def new
    @comanda = Comanda.new
  end

  # GET /comandas/1/edit
  def edit
  end

  # POST /comandas or /comandas.json
  def create1 #aceasta metoda este fosta create  care a fost creata cu scaffold si am renuntat la ea
    @comanda = Comanda.new(comanda_params)

    respond_to do |format|
      if @comanda.save
        format.html { redirect_to comanda_url(@comanda), notice: "Comanda was successfully created." }
        format.json { render :show, status: :created, location: @comanda }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comanda.errors, status: :unprocessable_entity }
      end
    end
  end

  def create #folosesc aceasta metoda pentru a adauga manual o comanda care e prin banca si NU prin Stripe
    
    user = User.find_by(email: params[:comanda][:emailcurrent])
    unless user
      redirect_to new_comanda_path, alert: 'Userul nu a fost găsit.' and return
    end
    @comanda = Comanda.new(comanda_params)
    @comanda.user_id = user.id if user
    @comanda.datacomenzii = Time.now
    @comanda.statecomanda1 = 'Initiata'
    @comanda.statecomanda2 = 'Finalizata'
    @comanda.stateplata1 = 'Achitata'
    @comanda.telefon = user.telefon
    #@comanda.plataprin = 'alta modalitate'
    @prod = Prod.find_by(id: comanda_params[:prodid]) # presupunem că Prod este numele modelului tău
    if @prod
      @comanda.stateplata3 = "acces #{@prod.valabilitatezile} zile"
      @comanda.stateplata2 = @prod.pret
      @comanda.total = @prod.pret
    else
      # dă o valoare implicită sau lasă necompletat, în caz că produsul nu există
      @comanda.stateplata3 = "negasit"
    end
    max_numar = Comanda.maximum(:numar)
    next_numar = max_numar ? max_numar + 1 : 1
  
    @comanda.numar = next_numar


   


    if @prod
    respond_to do |format|
      if @comanda.save
        # Adaugă produsul la comandă
        ComenziProd.create!(
          comanda_id: @comanda.id,
          prod_id: @comanda.prodid,
          user_id: @comanda.user_id,
          validat: 'Finalizata',
          datainceput: Time.now,
          datasfarsit: Time.now + Prod.find(@comanda.prodid).valabilitatezile.to_i.days

        )

        
        
        format.html { redirect_to comanda_url(@comanda), notice: "Comanda a fost creată cu succes." }
        format.json { render :show, status: :created, location: @comanda }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comanda.errors, status: :unprocessable_entity }
      end
    end
  end
  end


  # PATCH/PUT /comandas/1 or /comandas/1.json
  def update
    respond_to do |format|
      if @comanda.update(comanda_params)
        format.html { redirect_to comanda_url(@comanda), notice: "Comanda was successfully updated." }
        format.json { render :show, status: :ok, location: @comanda }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comanda.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comandas/1 or /comandas/1.json
  def destroy
    @comanda.destroy

    respond_to do |format|
      format.html { redirect_to comandas_url, notice: "Comanda was successfully destroyed." }
      format.json { head :no_content }
    end
  end
####################
def index11
  @comenzi_prod1 = ComenziProd1.all.order(id: :desc)
end  
def new11  
  @comenzi_prod1 = ComenziProd1.new
end

def edit11  
  
end
def create11
  @comenzi_prod1 = ComenziProd1.new(comenziprod1_params)
  puts("ComenziProd1 este: #{@comenzi_prod1.id}")

  if @comenzi_prod1.save
    redirect_to index11_comandas_path, notice: 'Comanda produs a fost creată cu succes.'
  else
    puts @comenzi_prod1.errors.full_messages
    render :new11, status: :unprocessable_entity
  end
end


def update11
  if @comenzi_prod1.update(comenziprod1_params)
    redirect_to index11_comandas_path, notice: 'Comanda produs a fost actualizată cu succes.'
  else
    render :edit11
  end
end
def destroy11
  @comenzi_prod1.destroy
  redirect_to index11_comandas_path, notice: 'Comanda produs a fost ștearsă.'
end

####################
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comanda
      @comanda = Comanda.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comanda_params
      params.require(:comanda).permit(:datacomenzii, :numar, :statecomanda1, :statecomanda2, :stateplata1, :stateplata2, :stateplata3, :user_id, :emailcurrent, :emailplata, :total, :plataprin, :prodid, :prodcod, :telefon)
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

    def comenziprod_params
      params.require(:comenzi_prod).permit(:user_id, :prod_id, :comanda_id, :datainceput, :datasfarsit, :validat, :taxa2324, :cantitate, :pret_bucata, :pret_total, :obs)
    end
    def comenziprod1_params
      params.require(:comenzi_prod1).permit(:user_id, :prod_id, :comanda_id, :datainceput, :datasfarsit, :validat, :taxa2324, :cantitate, :pret_bucata, :pret_total, :obs)
    end
    def set_comenzi_prod1
      @comenzi_prod1 = ComenziProd1.find(params[:id])
    end

end
