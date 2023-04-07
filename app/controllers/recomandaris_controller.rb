class RecomandarisController < ApplicationController
  before_action :set_recomandari, only: %i[ show edit update destroy ]

  # GET /recomandaris or /recomandaris.json
  def index
    @recomandaris = Recomandari.all
  end

  # GET /recomandaris/1 or /recomandaris/1.json
  def show
  end

  # GET /recomandaris/new
  def new
    @recomandari = Recomandari.new
  end

  # GET /recomandaris/1/edit
  def edit
  end

  # POST /recomandaris or /recomandaris.json
  def create
    @recomandari = Recomandari.new(recomandari_params)

    respond_to do |format|
      if @recomandari.save
        format.html { redirect_to recomandari_url(@recomandari), notice: "Recomandari was successfully created." }
        format.json { render :show, status: :created, location: @recomandari }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @recomandari.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recomandaris/1 or /recomandaris/1.json
  def update
    respond_to do |format|
      if @recomandari.update(recomandari_params)
        format.html { redirect_to recomandari_url(@recomandari), notice: "Recomandari was successfully updated." }
        format.json { render :show, status: :ok, location: @recomandari }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @recomandari.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recomandaris/1 or /recomandaris/1.json
  def destroy
    @recomandari.destroy

    respond_to do |format|
      format.html { redirect_to recomandaris_url, notice: "Recomandari was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recomandari
      @recomandari = Recomandari.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def recomandari_params
      params.require(:recomandari).permit(:listaproprietati_id, :idpr, :idp, :idpp, :imp, :tipp, :srota, :proprietate, :propeng, :propayur, :propgerm, :completari, :sursa, :sel)
    end
end
