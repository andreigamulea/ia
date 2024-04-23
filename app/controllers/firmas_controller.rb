class FirmasController < ApplicationController
  before_action :set_firma, only: %i[ show edit update destroy ]

  # GET /firmas or /firmas.json
  def index
    @firmas = Firma.all
  end

  # GET /firmas/1 or /firmas/1.json
  def show
  end

  # GET /firmas/new
  def new
    @firma = Firma.new
  end

  # GET /firmas/1/edit
  def edit
  end

  # POST /firmas or /firmas.json
  def create
    @firma = Firma.new(firma_params)

    respond_to do |format|
      if @firma.save
        format.html { redirect_to firma_url(@firma), notice: "Firma was successfully created." }
        format.json { render :show, status: :created, location: @firma }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @firma.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /firmas/1 or /firmas/1.json
  def update
    respond_to do |format|
      if @firma.update(firma_params)
        format.html { redirect_to firma_url(@firma), notice: "Firma was successfully updated." }
        format.json { render :show, status: :ok, location: @firma }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @firma.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /firmas/1 or /firmas/1.json
  def destroy
    @firma.destroy

    respond_to do |format|
      format.html { redirect_to firmas_url, notice: "Firma was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_firma
      @firma = Firma.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def firma_params
      params.require(:firma).permit(:nume_institutie, :cui, :rc, :adresa, :banca, :cont, :serie, :nrinceput, :cod)
    end
end
