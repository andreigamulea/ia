class FacturasController < ApplicationController 
  require 'zip'
  before_action :set_factura, only: %i[ show edit update destroy ]
  before_action :set_user, only: %i[index show edit update destroy]
  #before_action :set_factura1, only: [:download_all]

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
  def facturicomenzi
    #aceasta metoda ordoneaza facturile in functie de cate sunt pt o comanda
    #pentru a vedea daca am 2 sau mai multe facturi pt aceeasi comanda desi nu ar trebui
    @facturas = Factura
  .select('facturas.*, subquery.factura_count')
  .joins("LEFT JOIN (
      SELECT comanda_id, COUNT(id) as factura_count
      FROM facturas
      GROUP BY comanda_id
    ) AS subquery ON facturas.comanda_id = subquery.comanda_id")
  .order('subquery.factura_count DESC, facturas.comanda_id DESC')




  end  


  def download
    factura = Factura.find(params[:id])
    # logica pentru generarea PDF-ului aici
  end
  def download1
    if current_user.role==1
    @facturas = Factura.all # Aici obținem toate facturile
    # Adaugă orice alte verificări de securitate necesare aici
    #puts @facturas.inspect
    respond_to do |format|
      format.html
      format.pdf do
        html = render_to_string(
          template: 'facturas/download1',
          locals: { facturas: @facturas },
          encoding: 'UTF8'
        )
        pdf = PDFKit.new(html).to_pdf
        send_data pdf, filename: "Toate_Facturile.pdf",
          type: 'application/pdf',
          disposition: 'attachment'
      end
    end
  end
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
  def download_all
    @user = User.find_by(id: 222)
  
    # Selecționează facturile cu numărul de la 1001 la 1010
    facturas = Factura.where(numar: 1001..1010)
  
    # Cream un fișier zip temporar
    zipfile_name = Tempfile.new(["facturas", ".zip"], Dir.tmpdir)
  
    # Populăm fișierul ZIP cu PDF-uri generate
    Zip::File.open(zipfile_name.path, Zip::File::CREATE) do |zipfile|
      facturas.each do |factura|
        Rails.logger.info "Processing factura: #{factura.inspect}"
        next unless factura && (factura.user_id == @user.id || @user.role == 1)
  
        pdf = generate_pdf_for_factura(factura)
        zipfile.get_output_stream("Factura_#{factura.id}.pdf") { |f| f.write(pdf) }
      end
    end
  
    # Trimitem fișierul ZIP spre descărcare
    send_file zipfile_name.path, type: 'application/zip', disposition: 'attachment', filename: "facturas.zip"
  ensure
    # Asigurați-vă că fișierul temporar este șters după ce a fost trimis
    if zipfile_name
      zipfile_name.close
      zipfile_name.unlink
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
    def set_factura1
      @factura = Factura.find(params[:id])
    end
    
    # Only allow a list of trusted parameters through.
    def factura_params
      params.require(:factura).permit(:comanda_id, :user_id, :numar, :numar_comanda, :data_emiterii, :prenume, :nume, :nume_companie, :cui, :tara, :localitate, :judet, :cod_postal, :strada, :numar_adresa, :produs, :cantitate, :pret_unitar, :valoare_tva, :valoare_totala, :status)
    end
    def set_user
      @user = current_user # presupunând că current_user este disponibil
    end
    def generate_pdf_for_factura(factura)
      html = render_to_string(
        template: 'facturas/download1',   # Aici folosim același template ca în download1
        locals: { factura: factura },
        encoding: 'UTF8'
      )
      PDFKit.new(html).to_pdf
    end
    
    
    
    
end
