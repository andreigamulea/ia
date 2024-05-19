class FacturaproformasController < ApplicationController
  before_action :set_facturaproforma, only: %i[ show edit update destroy ]

  # GET /facturaproformas or /facturaproformas.json
  def index
    @facturaproformas = Facturaproforma.all
  end

  # GET /facturaproformas/1 or /facturaproformas/1.json
  def show
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_facturaproforma
      @facturaproforma = Facturaproforma.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def facturaproforma_params
      params.require(:facturaproforma).permit(:comanda_id, :user_id, :prod_id, :numar_factura, :numar_comanda, :data_emiterii, :prenume, :nume, :nume_companie, :cui, :tara, :localitate, :judet, :strada, :numar_adresa, :cod_postal, :altedate, :telefon, :produs, :cantitate, :pret_unitar, :valoare_tva, :valoare_totala, :cod_firma, :status)
    end
end
