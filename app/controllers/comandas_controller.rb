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
  def create
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
      params.require(:comanda).permit(:datacomenzii, :numar, :statecomanda1, :statecomanda2, :stateplata1, :stateplata2, :stateplata3, :user_id, :emailcurrent, :emailplata, :total, :plataprin)
    end
end
