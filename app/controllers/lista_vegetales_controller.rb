class ListaVegetalesController < ApplicationController
  before_action :set_lista_vegetale, only: %i[ show edit update destroy ]

  # GET /lista_vegetales or /lista_vegetales.json
  def index
    @lista_vegetales = ListaVegetale.all
  end

  # GET /lista_vegetales/1 or /lista_vegetales/1.json
  def show
  end

  # GET /lista_vegetales/new
  def new
    @lista_vegetale = ListaVegetale.new
  end

  # GET /lista_vegetales/1/edit
  def edit
  end

  # POST /lista_vegetales or /lista_vegetales.json
  def create
    @lista_vegetale = ListaVegetale.new(lista_vegetale_params)

    respond_to do |format|
      if @lista_vegetale.save
        format.html { redirect_to lista_vegetale_url(@lista_vegetale), notice: "Lista vegetale was successfully created." }
        format.json { render :show, status: :created, location: @lista_vegetale }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @lista_vegetale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lista_vegetales/1 or /lista_vegetales/1.json
  def update
    respond_to do |format|
      if @lista_vegetale.update(lista_vegetale_params)
        format.html { redirect_to lista_vegetale_url(@lista_vegetale), notice: "Lista vegetale was successfully updated." }
        format.json { render :show, status: :ok, location: @lista_vegetale }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @lista_vegetale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lista_vegetales/1 or /lista_vegetales/1.json
  def destroy
    @lista_vegetale.destroy

    respond_to do |format|
      format.html { redirect_to lista_vegetales_url, notice: "Lista vegetale was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lista_vegetale
      @lista_vegetale = ListaVegetale.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def lista_vegetale_params
      params.require(:lista_vegetale).permit(:specie, :sinonime, :parteutilizata, :mentiunirestrictii)
    end
end
