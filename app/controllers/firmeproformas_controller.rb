class FirmeproformasController < ApplicationController
  before_action :set_firmeproforma, only: %i[ show edit update destroy ]

  # GET /firmeproformas or /firmeproformas.json
  def index
    @firmeproformas = Firmeproforma.all
  end

  # GET /firmeproformas/1 or /firmeproformas/1.json
  def show
  end

  # GET /firmeproformas/new
  def new
    @firmeproforma = Firmeproforma.new
  end

  # GET /firmeproformas/1/edit
  def edit
  end

  # POST /firmeproformas or /firmeproformas.json
  def create
    @firmeproforma = Firmeproforma.new(firmeproforma_params)

    respond_to do |format|
      if @firmeproforma.save
        format.html { redirect_to firmeproforma_url(@firmeproforma), notice: "Firmeproforma was successfully created." }
        format.json { render :show, status: :created, location: @firmeproforma }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @firmeproforma.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /firmeproformas/1 or /firmeproformas/1.json
  def update
    respond_to do |format|
      if @firmeproforma.update(firmeproforma_params)
        format.html { redirect_to firmeproforma_url(@firmeproforma), notice: "Firmeproforma was successfully updated." }
        format.json { render :show, status: :ok, location: @firmeproforma }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @firmeproforma.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /firmeproformas/1 or /firmeproformas/1.json
  def destroy
    @firmeproforma.destroy

    respond_to do |format|
      format.html { redirect_to firmeproformas_url, notice: "Firmeproforma was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_firmeproforma
      @firmeproforma = Firmeproforma.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def firmeproforma_params
      params.require(:firmeproforma).permit(:nume_institutie, :cui, :rc, :adresa, :banca, :cont, :serie, :nrinceput, :tva, :cod)
    end
end
