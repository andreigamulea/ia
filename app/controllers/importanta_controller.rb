class ImportantaController < ApplicationController
  before_action :set_importantum, only: %i[ show edit update destroy ]

  # GET /importanta or /importanta.json
  def index
    @importanta = Importantum.all
  end

  # GET /importanta/1 or /importanta/1.json
  def show
  end

  # GET /importanta/new
  def new
    @importantum = Importantum.new
  end

  # GET /importanta/1/edit
  def edit
  end

  # POST /importanta or /importanta.json
  def create
    @importantum = Importantum.new(importantum_params)

    respond_to do |format|
      if @importantum.save
        format.html { redirect_to importantum_url(@importantum), notice: "Importantum was successfully created." }
        format.json { render :show, status: :created, location: @importantum }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @importantum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /importanta/1 or /importanta/1.json
  def update
    respond_to do |format|
      if @importantum.update(importantum_params)
        format.html { redirect_to importantum_url(@importantum), notice: "Importantum was successfully updated." }
        format.json { render :show, status: :ok, location: @importantum }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @importantum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /importanta/1 or /importanta/1.json
  def destroy
    @importantum.destroy

    respond_to do |format|
      format.html { redirect_to importanta_url, notice: "Importantum was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_importantum
      @importantum = Importantum.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def importantum_params
      params.require(:importantum).permit(:codimp, :grad, :descgrad)
    end
end
