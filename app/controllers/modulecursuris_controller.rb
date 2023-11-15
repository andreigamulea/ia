class ModulecursurisController < ApplicationController
  before_action :set_modulecursuri, only: %i[ show edit update destroy ]

  # GET /modulecursuris or /modulecursuris.json
  def index
    @modulecursuris = Modulecursuri.all
  end

  # GET /modulecursuris/1 or /modulecursuris/1.json
  def show
  end

  # GET /modulecursuris/new
  def new
    @modulecursuri = Modulecursuri.new
  end

  # GET /modulecursuris/1/edit
  def edit
  end

  # POST /modulecursuris or /modulecursuris.json
  def create
    @modulecursuri = Modulecursuri.new(modulecursuri_params)

    respond_to do |format|
      if @modulecursuri.save
        format.html { redirect_to modulecursuri_url(@modulecursuri), notice: "Modulecursuri was successfully created." }
        format.json { render :show, status: :created, location: @modulecursuri }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @modulecursuri.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /modulecursuris/1 or /modulecursuris/1.json
  def update
    respond_to do |format|
      if @modulecursuri.update(modulecursuri_params)
        format.html { redirect_to modulecursuri_url(@modulecursuri), notice: "Modulecursuri was successfully updated." }
        format.json { render :show, status: :ok, location: @modulecursuri }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @modulecursuri.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /modulecursuris/1 or /modulecursuris/1.json
  def destroy
    @modulecursuri.destroy

    respond_to do |format|
      format.html { redirect_to modulecursuris_url, notice: "Modulecursuri was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_modulecursuri
      @modulecursuri = Modulecursuri.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def modulecursuri_params
      params.require(:modulecursuri).permit(:nume)
    end
end
