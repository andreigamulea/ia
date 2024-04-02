class FacturasController < ApplicationController 
  require 'zip'
  before_action :set_factura, only: %i[ show edit update destroy ]
  before_action :set_user, only: %i[index show edit update destroy]
  before_action :set_user_admin, only: %i[download_all download1 edit destroy facturicomenzi]
  #before_action :set_factura1, only: [:download_all]

  # GET /facturas or /facturas.json
  def index
    
    if !current_user
      redirect_to new_user_session_path   

    elsif @user.role == 1
      @facturas = Factura.all.order(id: :desc)
      #@facturas = @user.facturas
    elsif @user.role == 0
      @facturas = @user.facturas.where(status: nil)
    
    else
      #@facturas = @user.facturas
      # Cod pentru alte roluri sau un mesaj de eroare
    end
    Rails.logger.debug "@facturas: #{@facturas.inspect}"
    Rails.logger.debug "@user: #{@user.inspect}"

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
        filename_prefix = @factura.id + 1000 <= 1308 ? @factura.id + 1000 : @factura.id + 999
        filename = "Factura_#{filename_prefix}_din_#{@factura.data_emiterii.strftime('%d.%m.%Y')}.pdf"
        send_data pdf, filename: filename, type: 'application/pdf', disposition: 'attachment'
      end
    end
  end
  
  def download_all
    # Crearea unui folder temporar pentru stocarea PDF-urilor
    temp_folder = Rails.root.join('tmp', 'pdfs')
    FileUtils.mkdir_p(temp_folder)
    
    # Extrageți facturile pe care doriți să le includeți
    #facturas = Factura.where(numar: 1204..1542)#octombrie
    #facturas = Factura.where(numar: 1536..1654)#noiembrie
    #facturas = Factura.where(numar: 1649..1716)#decembrie
    #facturas = Factura.where(numar: 1713..1782)#ianuarie
    #facturas = Factura.where(numar: 1780..1922)#februarie
    facturas = Factura.where(numar: 1918..2037)#martie
    # Generați PDF-uri pentru fiecare factură
    pdf_files = facturas.map do |factura|
      @factura = factura
      html = render_to_string(
        template: 'facturas/show',
        locals: { factura: factura },
        encoding: 'UTF8'
      )
      pdf = PDFKit.new(html).to_pdf
      if factura.id + 1000<=1308
        file_path = temp_folder.join("Factura_#{factura.id + 1000}_din_#{factura.data_emiterii.strftime('%d.%m.%Y')}.pdf")
      else
        file_path = temp_folder.join("Factura_#{factura.id + 999}_din_#{factura.data_emiterii.strftime('%d.%m.%Y')}.pdf")
      end  

      File.open(file_path, 'wb') do |file|
        file << pdf
      end
      file_path
    end
    
    # Crearea fișierului ZIP
    zip_filename = Rails.root.join('tmp', 'facturas.zip')
    
    # Ștergeți fișierul ZIP preexistent dacă există
    File.delete(zip_filename) if File.exist?(zip_filename)

    Zip::File.open(zip_filename, Zip::File::CREATE) do |zipfile|
      pdf_files.each do |file|
        # Verificați dacă intrarea există înainte de a adăuga
        zipfile.add(File.basename(file), file) unless zipfile.find_entry(File.basename(file))
      end
    end
    
    # Trimiteți fișierul ZIP ca răspuns
    send_file zip_filename, type: 'application/zip', disposition: 'attachment', filename: 'facturas.zip'
    
    # Curățarea fișierelor temporare (păstrați această parte dacă doriți să ștergeți fișierele după descărcare)
    #FileUtils.rm_rf(temp_folder)
    #FileUtils.rm(zip_filename)
end


  
  
  def generate_pdf
    html = '<h1>Salutare!</h1><p>Acesta este un PDF simplu.</p>'
    pdf = PDFKit.new(html).to_pdf
    send_data pdf, filename: "simple.pdf", type: "application/pdf", disposition: "inline"
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
    

    def set_user_admin
      if !current_user
        redirect_to root_path, alert: "Nu ai permisiunea de a accesa această pagină."
        return
      end  
      unless current_user.role == 1
        redirect_to root_path, alert: "Nu ai permisiunea de a accesa această pagină."
        return
      end
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
