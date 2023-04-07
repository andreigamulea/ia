class TipuriPropsController < ApplicationController
  before_action :set_tipuri_prop, only: %i[ show edit update destroy ]

  # GET /tipuri_props or /tipuri_props.json
  def index
    @tipuri_props = TipuriProp.all
  end

  # GET /tipuri_props/1 or /tipuri_props/1.json
  def show
  end

  # GET /tipuri_props/new
  def new
    @tipuri_prop = TipuriProp.new
  end

  # GET /tipuri_props/1/edit
  def edit
  end

  # POST /tipuri_props or /tipuri_props.json
  def create
    @tipuri_prop = TipuriProp.new(tipuri_prop_params)

    respond_to do |format|
      if @tipuri_prop.save
        format.html { redirect_to tipuri_prop_url(@tipuri_prop), notice: "Tipuri prop was successfully created." }
        format.json { render :show, status: :created, location: @tipuri_prop }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tipuri_prop.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tipuri_props/1 or /tipuri_props/1.json
  def update
    respond_to do |format|
      if @tipuri_prop.update(tipuri_prop_params)
        format.html { redirect_to tipuri_prop_url(@tipuri_prop), notice: "Tipuri prop was successfully updated." }
        format.json { render :show, status: :ok, location: @tipuri_prop }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tipuri_prop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipuri_props/1 or /tipuri_props/1.json
  def destroy
    @tipuri_prop.destroy

    respond_to do |format|
      format.html { redirect_to tipuri_props_url, notice: "Tipuri prop was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipuri_prop
      @tipuri_prop = TipuriProp.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tipuri_prop_params
      params.require(:tipuri_prop).permit(:idxcp, :cp, :explicatie)
    end
end
