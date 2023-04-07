class ListacursurisController < ApplicationController
  before_action :set_listacursuri, only: %i[ show edit update destroy ]

  # GET /listacursuris or /listacursuris.json
  def index
    @listacursuris = Listacursuri.all
  end

  # GET /listacursuris/1 or /listacursuris/1.json
  def show
  end

  # GET /listacursuris/new
  def new
    @listacursuri = Listacursuri.new
  end

  # GET /listacursuris/1/edit
  def edit
  end

  # POST /listacursuris or /listacursuris.json
  def create
    @listacursuri = Listacursuri.new(listacursuri_params)

    respond_to do |format|
      if @listacursuri.save
        format.html { redirect_to listacursuri_url(@listacursuri), notice: "Listacursuri was successfully created." }
        format.json { render :show, status: :created, location: @listacursuri }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @listacursuri.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /listacursuris/1 or /listacursuris/1.json
  def update
    respond_to do |format|
      if @listacursuri.update(listacursuri_params)
        format.html { redirect_to listacursuri_url(@listacursuri), notice: "Listacursuri was successfully updated." }
        format.json { render :show, status: :ok, location: @listacursuri }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @listacursuri.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /listacursuris/1 or /listacursuris/1.json
  def destroy
    @listacursuri.destroy

    respond_to do |format|
      format.html { redirect_to listacursuris_url, notice: "Listacursuri was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listacursuri
      @listacursuri = Listacursuri.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def listacursuri_params
      params.require(:listacursuri).permit(:nume)
    end
end
