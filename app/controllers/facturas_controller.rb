class FacturasController < ApplicationController
  before_action :set_factura, only: %i[ show edit update destroy ]
  before_action :set_user, only: %i[index show edit update destroy]
  # GET /facturas or /facturas.json
  def index
    if @user.role == 1
      @facturas = Factura.all.order(id: :desc)
    elsif @user.role == 0
      @facturas = @user.facturas
    else
      # Cod pentru alte roluri sau un mesaj de eroare
    end
  end
  

  def download
    factura = Factura.find(params[:id])
    # logica pentru generarea PDF-ului aici
  end
  
  # GET /facturas/1 or /facturas/1.json
  def show
    @factura = Factura.find(params[:id])
    unless @factura.user_id == @user.id || @user.role == 1
      redirect_to root_path, alert: "Nu aveți permisiunea de a vizualiza această factură"
      return
    end
  
    respond_to do |format|
      format.html
      format.pdf do
        html = render_to_string(
          template: 'facturas/show',
          locals: { factura: @factura },
          encoding: 'UTF8'
        )
        pdf = PDFKit.new(html).to_pdf
        send_data pdf, filename: "Factura_#{@factura.id}.pdf",
          type: 'application/pdf',
          disposition: 'attachment'
      end
    end
  end
  

  # GET /facturas/new
  def new
    @factura = Factura.new
  end

  # GET /facturas/1/edit
  def edit
  end

  # POST /facturas or /facturas.json
  def create
    @factura = Factura.new(factura_params)

    respond_to do |format|
      if @factura.save
        format.html { redirect_to factura_url(@factura), notice: "Factura was successfully created." }
        format.json { render :show, status: :created, location: @factura }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @factura.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /facturas/1 or /facturas/1.json
  def update
    respond_to do |format|
      if @factura.update(factura_params)
        format.html { redirect_to factura_url(@factura), notice: "Factura was successfully updated." }
        format.json { render :show, status: :ok, location: @factura }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @factura.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /facturas/1 or /facturas/1.json
  def destroy
    @factura.destroy

    respond_to do |format|
      format.html { redirect_to facturas_url, notice: "Factura was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_factura
      @factura = Factura.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def factura_params
      params.require(:factura).permit(:comanda_id, :user_id, :numar, :numar_comanda, :data_emiterii, :prenume, :nume, :nume_companie, :cui, :tara, :localitate, :judet, :cod_postal, :strada, :numar_adresa, :produs, :cantitate, :pret_unitar, :valoare_tva, :valoare_totala)
    end
    def set_user
      @user = current_user # presupunând că current_user este disponibil
    end
end
