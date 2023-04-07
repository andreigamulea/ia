class CursurisController < ApplicationController
  before_action :set_cursuri, only: %i[ show edit update destroy ]

  # GET /cursuris or /cursuris.json
  def index
    @cursuris = Cursuri.all
  end

  # GET /cursuris/1 or /cursuris/1.json
  def show
  end

  # GET /cursuris/new
  def new
    @cursuri = Cursuri.new
  end

  # GET /cursuris/1/edit
  def edit
  end

  # POST /cursuris or /cursuris.json
  def create
    @cursuri = Cursuri.new(cursuri_params)

    respond_to do |format|
      if @cursuri.save
        format.html { redirect_to cursuri_url(@cursuri), notice: "Cursuri was successfully created." }
        format.json { render :show, status: :created, location: @cursuri }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cursuri.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cursuris/1 or /cursuris/1.json
  def update
    respond_to do |format|
      if @cursuri.update(cursuri_params)
        format.html { redirect_to cursuri_url(@cursuri), notice: "Cursuri was successfully updated." }
        format.json { render :show, status: :ok, location: @cursuri }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cursuri.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cursuris/1 or /cursuris/1.json
  def destroy
    @cursuri.destroy

    respond_to do |format|
      format.html { redirect_to cursuris_url, notice: "Cursuri was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cursuri
      @cursuri = Cursuri.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cursuri_params
      params.require(:cursuri).permit(:numecurs, :datainceput, :datasfarsit, :user_id)
    end
end
