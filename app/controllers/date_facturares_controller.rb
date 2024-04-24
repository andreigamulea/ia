class DateFacturaresController < ApplicationController
  before_action :set_date_facturare, only: %i[ show edit update destroy ]

  # GET /date_facturares or /date_facturares.json
  def index
    @date_facturares = DateFacturare.all
  end

  # GET /date_facturares/1 or /date_facturares/1.json
  def show
  end

  # GET /date_facturares/new
  def new
    #@date_facturare = DateFacturare.new
    @date_facturare = DateFacturare.new(user_id: current_user.id, email: current_user.email)
    email_exists = Listacanal3.exists?(email: current_user&.email)
    @has_access = current_user && (email_exists || current_user.role == 1)
  end

  # GET /date_facturares/1/edit
  def edit
  end

  # POST /date_facturares or /date_facturares.json
  def create
    @date_facturare = DateFacturare.new(date_facturare_params)

    respond_to do |format|
      if @date_facturare.save
        format.html { redirect_to date_facturare_url(@date_facturare), notice: "Date facturare was successfully created." }
        format.json { render :show, status: :created, location: @date_facturare }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @date_facturare.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /date_facturares/1 or /date_facturares/1.json
  def update
    respond_to do |format|
      if @date_facturare.update(date_facturare_params)
        format.html { redirect_to date_facturare_url(@date_facturare), notice: "Date facturare was successfully updated." }
        format.json { render :show, status: :ok, location: @date_facturare }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @date_facturare.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /date_facturares/1 or /date_facturares/1.json
  def destroy
    @date_facturare.destroy

    respond_to do |format|
      format.html { redirect_to date_facturares_url, notice: "Date facturare was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_date_facturare
      @date_facturare = DateFacturare.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def date_facturare_params
      params.require(:date_facturare).permit(:user_id, :firma_id, :email, :prenume, :nume, :numecompanie, :cui, :tara, :codpostal, :strada, :numar, :altedate, :telefon, :adresaemail, :localitate, :judet, :grupa2324, :cpa)
    end
end
