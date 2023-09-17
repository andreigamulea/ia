class ComandasController < ApplicationController
  before_action :set_comanda, only: %i[ show edit update destroy ]

  # GET /comandas or /comandas.json
  def index
    @comandas = Comanda.all.order(id: :desc)
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
    @comanda.plataprin = 'alta modalitate'
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comanda
      @comanda = Comanda.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comanda_params
      params.require(:comanda).permit(:datacomenzii, :numar, :statecomanda1, :statecomanda2, :stateplata1, :stateplata2, :stateplata3, :user_id, :emailcurrent, :emailplata, :total, :plataprin, :prodid, :prodcod, :telefon)
    end
end
