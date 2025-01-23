class FacturasController < ApplicationController 
  require 'zip'
  require 'builder'
  before_action :set_factura, only: %i[ show edit update destroy ]
  before_action :set_user, only: %i[index show edit update destroy]
  before_action :set_user_admin, only: %i[download_all download1 edit destroy facturicomenzi]
  #before_action :set_factura1, only: [:download_all]

  # GET /facturas or /facturas.json
  def index
    unless user_signed_in?
      flash[:alert] = "Trebuie să vă autentificați pentru acces."
      redirect_to new_user_session_path
      return false
    end
    if !current_user
      redirect_to new_user_session_path   

    elsif @user.role == 1
      @facturas = Factura.all.order(id: :desc)

      #@facturas = @user.facturas
    elsif @user.role == 0
      @facturas = @user.facturas.where(status: "Achitata")
    
    else
      #@facturas = @user.facturas
      # Cod pentru alte roluri sau un mesaj de eroare
    end
    Rails.logger.debug "@facturas: #{@facturas.inspect}"
    Rails.logger.debug "@user: #{@user.inspect}"
    ###
    if !current_user
      redirect_to new_user_session_path   

    elsif @user.role == 1
      @facturasp = Facturaproforma.all.order(id: :desc)
      
      #@facturas = @user.facturas
    elsif @user.role == 0
      @facturasp = @user.facturaproformas.where(status: ["Achitata", "Proforma"]).order(id: :desc)

    
    else
      #@facturas = @user.facturas
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
  

  def facturi_xml
    unless user_signed_in?
      flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
      redirect_to new_user_session_path
      return false
    end
  
    unless current_user.role == 1
      flash[:alert] = "Nu aveți permisiunea de a accesa această pagină."
      redirect_to root_path
      return false
    end
    @facturas = Factura.order(created_at: :asc)
    @facturas_pe_firma = @facturas.select { |factura| factura.cui =~ /\d{2,}/ }
    @facturas_persoana_fizica = @facturas - @facturas_pe_firma
  end

  def facturi_xml_ayushcell
    unless user_signed_in?
      flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
      redirect_to new_user_session_path
      return false
    end
  
    unless current_user.role == 1
      flash[:alert] = "Nu aveți permisiunea de a accesa această pagină."
      redirect_to root_path
      return false
    end
    @facturas = Factura.order(created_at: :desc)
    @facturas_pe_firma = @facturas.select { |factura| factura.cui =~ /\d{2,}/ }
    @facturas_persoana_fizica = @facturas - @facturas_pe_firma
  end

  def download_xml
    unless user_signed_in?
      flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
      redirect_to new_user_session_path
      return false
    end
  
    unless current_user.role == 1
      flash[:alert] = "Nu aveți permisiunea de a accesa această pagină."
      redirect_to root_path
      return false
    end
    factura = Factura.find(params[:id])
    xml = factura.cui =~ /\d{2,}/ ? generate_invoice_xml_company(factura) : generate_invoice_xml_individual(factura)
    supplier_cui = '5509227'  # Codul fiscal al furnizorului
    filename = "F_#{supplier_cui}_ACDA#{factura.numar}_#{factura.created_at.strftime('%d-%m-%Y')}.xml"
  
    send_data xml, type: 'application/xml', filename: filename
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
  
  def raport_accesare_facturi
    start_date = DateTime.parse('2024-06-05')
    @report = {}

    # Extrage înregistrările din ahoy_events după data specificată
    events = Ahoy::Event.where('time > ?', start_date)

    # Faza 1: Procesare facturas#index
    events.where(name: 'Processed facturas#index').each do |event|
      user_id = event.user_id
      next unless user_id # Sare peste evenimentele fără user_id

      user = Factura.find_by(user_id: user_id)

      # Dacă nu găsim user în Factura, încercăm în Facturaproforma
      if user
        full_name = "#{user.prenume} #{user.nume}"
      else
        proforma_user = Facturaproforma.find_by(user_id: user_id)
        if proforma_user
          full_name = proforma_user.nume
        else
          # Dacă nu găsim user nici în Factura, nici în Facturaproforma, căutăm în User
          user_record = User.find_by(id: user_id)
          full_name = user_record ? user_record.name : '-'
        end
      end

      # Obținem emailul utilizatorului din tabela User
      user_record = User.find_by(id: user_id)
      email = user_record ? user_record.email : nil

      # Verifică dacă există date în tabela date_facturare
      date_facturare_record = DateFacturare.find_by(user_id: user_id)
      an_curs = if date_facturare_record
                  date_facturare_record.grupa2324
                else
                  user_record ? user_record.grupa : '-'
                end

      # Setăm an_curs la "2023-2024" dacă grupa este găsită în tabela User
      an_curs = "2023-2024" if user_record && user_record.grupa == "2023-2024"

      if @report[user_id]
        @report[user_id][:numar_accesari] += 1
        @report[user_id][:data_accesare_pagina] = [event.time, @report[user_id][:data_accesare_pagina]].max
      else
        @report[user_id] = {
          user_id: user_id,
          nume: full_name,
          data_accesare_pagina: event.time,
          numar_accesari: 1,
          numar_download: 0,
          data_ultimului_download: nil,
          an_curs: an_curs,
          email: email
        }
      end
    end

    # Faza 2: Procesare facturaproformas#show
    events.where(name: 'Processed facturaproformas#show').each do |event|
      user_id = event.user_id
      next unless user_id # Sare peste evenimentele fără user_id
      next unless @report[user_id]

      @report[user_id][:numar_download] += 1
      @report[user_id][:data_ultimului_download] = [event.time, @report[user_id][:data_ultimului_download]].compact.max
    end

    # Verifică dacă emailul există în tabela listacanal3 și setează an_curs la 3 dacă este găsit
    @report.each do |user_id, record|
      if record[:email]
        listacanal3_record = Listacanal3.find_by(email: record[:email])
        record[:an_curs] = '3' if listacanal3_record
      end
      record.delete(:email) # Elimină emailul din raport
    end

    # Convertim hash-ul la array și sortăm după an_curs
    @report = @report.values.sort_by { |record| record[:an_curs] == '3' ? 0 : 1 }
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
    # Preluarea parametrilor din request
    luna = params[:luna]&.to_i || Date.today.month
    an = params[:an]&.to_i || Date.today.year
    logger.info "Luna: #{luna}, An: #{an}"
  
    # Obține numele complet al lunii
    nume_luna = Date::MONTHNAMES[luna]
  
    # Crearea unui folder temporar pentru stocarea PDF-urilor
    temp_folder = Rails.root.join('tmp', 'pdfs')
    FileUtils.mkdir_p(temp_folder)
  
    # Selectarea facturilor din luna și anul specificate
    facturas = Factura.where('extract(month from data_emiterii) = ? AND extract(year from data_emiterii) = ?', luna, an)
    logger.info "Facturi găsite: #{facturas.count}"
  
    # Generarea PDF-urilor pentru fiecare factură
    pdf_files = facturas.map do |factura|
      logger.info "Generăm PDF pentru factura #{factura.numar}"
      @factura = factura
  
      # Generarea HTML-ului pentru factură
      html = render_to_string(
        template: 'facturas/show',
        locals: { factura: factura },
        encoding: 'UTF8'
      )
  
      # Conversia HTML-ului în PDF
      pdf = PDFKit.new(html).to_pdf
  
      # Generarea numelui fișierului
      file_path = if factura.id + 1000 <= 1308
                    temp_folder.join("Factura_#{factura.id + 1000}_din_#{factura.data_emiterii.strftime('%d.%m.%Y')}.pdf")
                  else
                    temp_folder.join("Factura_#{factura.id + 999}_din_#{factura.data_emiterii.strftime('%d.%m.%Y')}.pdf")
                  end
  
      # Scrierea fișierului PDF pe disc
      File.open(file_path, 'wb') do |file|
        file << pdf
      end
  
      file_path
    end
  
    # Crearea fișierului ZIP
    zip_filename = Rails.root.join('tmp', "Facturi_luna_#{nume_luna}_#{an}.zip")
  
    # Ștergerea fișierului ZIP existent, dacă există
    File.delete(zip_filename) if File.exist?(zip_filename)
  
    # Adăugarea fișierelor PDF în arhiva ZIP
    Zip::File.open(zip_filename, Zip::File::CREATE) do |zipfile|
      pdf_files.each do |file|
        zipfile.add(File.basename(file), file) unless zipfile.find_entry(File.basename(file))
      end
    end
  
    # Trimiteți fișierul ZIP ca răspuns
    logger.info "Trimitem fișierul ZIP către browser: #{zip_filename}"
    send_file zip_filename,
              type: 'application/zip',
              disposition: 'attachment',
              filename: "Facturi_PDF_luna_#{nume_luna}_#{an}.zip"
  
    # Opțional: Curățarea fișierelor temporare după descărcare
    # FileUtils.rm_rf(temp_folder)
    # FileUtils.rm(zip_filename)
  end
  
    
    

  def download_all_xml
    # Preluarea parametrilor din request
    luna = params[:luna]&.to_i || Date.today.month
    an = params[:an]&.to_i || Date.today.year
    logger.info "Luna: #{luna}, An: #{an}"
  
    # Obține numele complet al lunii
    nume_luna = Date::MONTHNAMES[luna]
  
    # Crearea unui folder temporar pentru stocarea XML-urilor
    temp_folder = Rails.root.join('tmp', 'xmls')
    FileUtils.mkdir_p(temp_folder)
  
    # Selectarea facturilor doar din luna și anul specificate
    facturas = Factura.where('extract(month from data_emiterii) = ? AND extract(year from data_emiterii) = ?', luna, an)
    logger.info "Facturi găsite: #{facturas.count}"
  
    # Generarea XML-urilor pentru fiecare factură
    xml_files = facturas.map do |factura|
      logger.info "Generăm XML pentru factura #{factura.numar}"
      xml_content = factura.cui =~ /\d{2,}/ ? generate_invoice_xml_company(factura) : generate_invoice_xml_individual(factura)
  
      # Generarea numelui fișierului
      file_path = temp_folder.join("Factura_#{factura.numar}_din_#{factura.data_emiterii.strftime('%d.%m.%Y')}.xml")
  
      # Scrierea conținutului XML în fișier
      File.open(file_path, 'wb') do |file|
        file << xml_content
      end
      file_path
    end
  
    # Crearea fișierului ZIP
    zip_filename = Rails.root.join('tmp', "Facturi_XML_luna_#{nume_luna}_#{an}.zip")
  
    # Ștergeți fișierul ZIP preexistent dacă există
    File.delete(zip_filename) if File.exist?(zip_filename)
  
    Zip::File.open(zip_filename, Zip::File::CREATE) do |zipfile|
      xml_files.each do |file|
        zipfile.add(File.basename(file), file) unless zipfile.find_entry(File.basename(file))
      end
    end
  
    # Trimiteți fișierul ZIP către browser
    logger.info "Trimitem fișierul ZIP către browser: #{zip_filename}"
    send_file zip_filename,
              type: 'application/zip',
              disposition: 'attachment',
              filename: "Facturi_XML_luna_#{nume_luna}_#{an}.zip"
  
    # Ștergerea fișierelor temporare după descărcare (opțional)
    # FileUtils.rm_rf(temp_folder)
    # FileUtils.rm(zip_filename)
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
      params.require(:factura).permit(:comanda_id, :user_id, :numar, :numar_comanda, :data_emiterii, :prenume, :nume, :nume_companie, :cui, :tara, :localitate, :judet, :cod_postal, :strada, :numar_adresa, :produs, :cantitate, :pret_unitar, :valoare_tva, :valoare_totala, :status, :cnp, :abr_jud)
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
    
    
    
    ### metoda PJ start
    def generate_invoice_xml_company(factura)
      builder = Builder::XmlMarkup.new(indent: 2)
      builder.Invoice(
        'xmlns:cbc' => "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2",
        'xmlns:udt' => "urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2",
        'xmlns:cac' => "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2",
        'xmlns:ccts' => "urn:un:unece:uncefact:documentation:2",
        'xmlns' => "urn:oasis:names:specification:ubl:schema:xsd:Invoice-2",
        'xmlns:qdt' => "urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2",
        'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance"
      ) do |invoice|
        invoice.cbc :UBLVersionID, '2.1'
        invoice.cbc :CustomizationID, 'urn:cen.eu:en16931:2017#compliant#urn:efactura.mfinante.ro:CIUS-RO:1.0.1'
        invoice.cbc :ID, "ACDA#{factura.numar}"
        invoice.cbc :IssueDate, factura.created_at.strftime('%Y-%m-%d')
        invoice.cbc :DueDate, factura.created_at.strftime('%Y-%m-%d')
        invoice.cbc :InvoiceTypeCode, '380'
        invoice.cbc :Note, 'TVA la incasare'
        invoice.cbc :Note, "Nr.comanda: #{factura.comanda_id}"
        invoice.cbc :DocumentCurrencyCode, 'RON'
        invoice.cbc :TaxCurrencyCode, 'RON'
    
        invoice.cac :AccountingSupplierParty do |supplier|
          supplier.cac :Party do |party|
            party.cbc :EndpointID, 'doringrasu@gmail.com', schemeID: 'EM'
            party.cac :PartyIdentification do |identification|
              identification.cbc :ID, '5509227'
            end
            party.cac :PostalAddress do |address|
              address.cbc :StreetName, 'str. OSTASILOR nr. 15 et. P ap. 1A'
              address.cbc :CityName, 'SECTOR1'
              address.cbc :CountrySubentity, 'RO-B'
              address.cac :Country do |country|
                country.cbc :IdentificationCode, 'RO'
              end
            end
            party.cac :PartyTaxScheme do |tax_scheme|
              tax_scheme.cbc :CompanyID, 'RO5509227'
              tax_scheme.cac :TaxScheme do |tax|
                tax.cbc :ID, 'VAT'
              end
            end
            party.cac :PartyLegalEntity do |legal_entity|
              legal_entity.cbc :RegistrationName, 'S.C. AYUSH CELL ROMANIA S.R.L.'
              legal_entity.cbc :CompanyID, 'J40/6720/1994'
            end
            party.cac :Contact do |contact|
              contact.cbc :Name, 'GAMULEA ANDREI FLORIN'
              contact.cbc :Telephone, '0749079619'
              contact.cbc :ElectronicMail, 'doringrasu@gmail.com'
            end
          end
        end
    
        invoice.cac :AccountingCustomerParty do |customer|
          customer.cac :Party do |party|
            party.cac :PartyIdentification do |identification|
              identification.cbc :ID, factura.cui
            end
            party.cac :PostalAddress do |address|
              address.cbc :StreetName, "#{factura.strada}, NR. #{factura.numar_adresa}"
              address.cbc :CityName, factura.localitate              
              address.cbc :CountrySubentity, "#{get_country_abbreviation(factura.tara)}-#{factura.abr_jud}"
              address.cac :Country do |country|
                country.cbc :IdentificationCode, get_country_abbreviation(factura.tara)
              end
            end
            party.cac :PartyTaxScheme do |tax_scheme|
              tax_scheme.cbc :CompanyID, factura.cui
              tax_scheme.cac :TaxScheme do |tax|
                tax.cbc :ID, 'VAT'
              end
            end
            party.cac :PartyLegalEntity do |legal_entity|
              legal_entity.cbc :RegistrationName, factura.nume_companie if factura.nume_companie.present?
              legal_entity.cbc :CompanyID, factura.cui
            end
          end
        end
    
        invoice.cac :PaymentMeans do |payment|
          payment.cbc :PaymentMeansCode, '42'
          payment.cac :PayeeFinancialAccount do |account|
            account.cbc :ID, 'RO53INGB0000999902918784'
            account.cbc :Name, 'ING BANK ROMANIA'
          end
        end
    
        # Totalul inclusiv TVA
      total_with_vat = factura.valoare_totala

      # Calculează valoarea fără TVA
      total_without_vat = (total_with_vat / 1.19).round(2)

      # Calculează TVA-ul ca diferența dintre total și valoarea fără TVA
      vat_amount = (total_with_vat - total_without_vat).round(2)

      # Generează XML-ul
      invoice.cac :TaxTotal do |tax_total|
        tax_total.cbc :TaxAmount, vat_amount, currencyID: 'RON'
        tax_total.cac :TaxSubtotal do |tax_subtotal|
          tax_subtotal.cbc :TaxableAmount, total_without_vat, currencyID: 'RON'
          tax_subtotal.cbc :TaxAmount, vat_amount, currencyID: 'RON'
          tax_subtotal.cac :TaxCategory do |tax_category|
            tax_category.cbc :ID, 'S'
            tax_category.cbc :Percent, 19.0
            tax_category.cac :TaxScheme do |tax_scheme|
              tax_scheme.cbc :ID, 'VAT'
            end
          end
        end
      end
    
        invoice.cac :LegalMonetaryTotal do |total|
          total.cbc :LineExtensionAmount, total_without_vat, currencyID: 'RON'
          total.cbc :TaxExclusiveAmount, total_without_vat, currencyID: 'RON'
          total.cbc :TaxInclusiveAmount, total_with_vat, currencyID: 'RON'
          total.cbc :PayableAmount, total_with_vat, currencyID: 'RON'
        end
    
        invoice.cac :InvoiceLine do |line|
          line.cbc :ID, '1'
          line.cbc :InvoicedQuantity, factura.cantitate, unitCode: 'E48'
          line.cbc :LineExtensionAmount, total_without_vat, currencyID: 'RON'
          line.cac :Item do |item|
            item.cbc :Description, "Comanda nr. #{factura.comanda_id}"
            item.cbc :Name, "SERVICII ONLINE: #{factura.produs}"
            item.cac :ClassifiedTaxCategory do |tax_category|
              tax_category.cbc :ID, 'S'
              tax_category.cbc :Percent, factura.valoare_tva
              tax_category.cac :TaxScheme do |tax_scheme|
                tax_scheme.cbc :ID, 'VAT'
              end
            end
          end
          line.cac :Price do |price|
            price.cbc :PriceAmount, factura.pret_unitar, currencyID: 'RON'
          end
        end
      end
    
      builder.target!
    end
    
    ###metoda PJ final
  
  ###metoda PF start
  def generate_invoice_xml_individual(factura)
    builder = Builder::XmlMarkup.new(indent: 2)
    builder.Invoice(
      'xmlns:cbc' => "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2",
      'xmlns:udt' => "urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2",
      'xmlns:cac' => "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2",
      'xmlns:ccts' => "urn:un:unece:uncefact:documentation:2",
      'xmlns' => "urn:oasis:names:specification:ubl:schema:xsd:Invoice-2",
      'xmlns:qdt' => "urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2",
      'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance"
    ) do |invoice|
      invoice.cbc :UBLVersionID, '2.1'
      invoice.cbc :CustomizationID, 'urn:cen.eu:en16931:2017#compliant#urn:efactura.mfinante.ro:CIUS-RO:1.0.1'
      invoice.cbc :ID, "ACDA#{factura.numar}"
      invoice.cbc :IssueDate, factura.created_at.strftime('%Y-%m-%d')
      invoice.cbc :DueDate, factura.created_at.strftime('%Y-%m-%d')
      invoice.cbc :InvoiceTypeCode, '380'
      invoice.cbc :Note, 'TVA la incasare'
      invoice.cbc :Note, "Nr.comanda: #{factura.comanda_id}"
      invoice.cbc :DocumentCurrencyCode, 'RON'
      invoice.cbc :TaxCurrencyCode, 'RON'
  
      invoice.cac :AccountingSupplierParty do |supplier|
        supplier.cac :Party do |party|
          party.cbc :EndpointID, 'doringrasu@gmail.com', schemeID: 'EM'
          party.cac :PartyIdentification do |identification|
            identification.cbc :ID, '5509227'
          end
          party.cac :PostalAddress do |address|
            address.cbc :StreetName, 'str. OSTASILOR nr. 15 et. P ap. 1A'
            address.cbc :CityName, 'SECTOR1'
            address.cbc :CountrySubentity, 'RO-B'
            address.cac :Country do |country|
              country.cbc :IdentificationCode, 'RO'
            end
          end
          party.cac :PartyTaxScheme do |tax_scheme|
            tax_scheme.cbc :CompanyID, 'RO5509227'
            tax_scheme.cac :TaxScheme do |tax|
              tax.cbc :ID, 'VAT'
            end
          end
          party.cac :PartyLegalEntity do |legal_entity|
            legal_entity.cbc :RegistrationName, 'S.C. AYUSH CELL ROMANIA S.R.L.'
            legal_entity.cbc :CompanyID, 'J40/6720/1994'
          end
          party.cac :Contact do |contact|
            contact.cbc :Name, 'GAMULEA ANDREI FLORIN'
            contact.cbc :Telephone, '0749079619'
            contact.cbc :ElectronicMail, 'doringrasu@gmail.com'
          end
        end
      end
  
      invoice.cac :AccountingCustomerParty do |customer|
        customer.cac :Party do |party|
          party.cac :PartyIdentification do |identification|
            identification.cbc :ID, factura.cnp
          end
          party.cac :PostalAddress do |address|
            address.cbc :StreetName, "#{factura.strada}, NR. #{factura.numar_adresa}"
            address.cbc :CityName, factura.localitate
            address.cbc :CountrySubentity, "#{get_country_abbreviation(factura.tara)}-#{factura.abr_jud}"
            address.cac :Country do |country|
              country.cbc :IdentificationCode, get_country_abbreviation(factura.tara)
            end
          end
          party.cac :PartyTaxScheme do |tax_scheme|
            tax_scheme.cbc :CompanyID, factura.cui
            tax_scheme.cac :TaxScheme do |tax|
              tax.cbc :ID, 'VAT'
            end
          end
          party.cac :PartyLegalEntity do |legal_entity|
            legal_entity.cbc :RegistrationName, "#{factura.nume} #{factura.prenume}"
            legal_entity.cbc :CompanyID, factura.cui
          end
        end
      end
  
      invoice.cac :PaymentMeans do |payment|
        payment.cbc :PaymentMeansCode, '42'
        payment.cac :PayeeFinancialAccount do |account|
          account.cbc :ID, 'RO53INGB0000999902918784'
          account.cbc :Name, 'ING BANK ROMANIA'
        end
      end
  
      # Totalul inclusiv TVA
      total_with_vat = factura.valoare_totala

      # Calculează valoarea fără TVA
      total_without_vat = (total_with_vat / 1.19).round(2)

      # Calculează TVA-ul ca diferența dintre total și valoarea fără TVA
      vat_amount = (total_with_vat - total_without_vat).round(2)

      # Generează XML-ul
      invoice.cac :TaxTotal do |tax_total|
        tax_total.cbc :TaxAmount, vat_amount, currencyID: 'RON'
        tax_total.cac :TaxSubtotal do |tax_subtotal|
          tax_subtotal.cbc :TaxableAmount, total_without_vat, currencyID: 'RON'
          tax_subtotal.cbc :TaxAmount, vat_amount, currencyID: 'RON'
          tax_subtotal.cac :TaxCategory do |tax_category|
            tax_category.cbc :ID, 'S'
            tax_category.cbc :Percent, 19.0
            tax_category.cac :TaxScheme do |tax_scheme|
              tax_scheme.cbc :ID, 'VAT'
            end
          end
        end
      end
  
      invoice.cac :LegalMonetaryTotal do |total|
        total.cbc :LineExtensionAmount, total_without_vat, currencyID: 'RON'
        total.cbc :TaxExclusiveAmount, total_without_vat, currencyID: 'RON'
        total.cbc :TaxInclusiveAmount, total_with_vat, currencyID: 'RON'
        total.cbc :PayableAmount, total_with_vat, currencyID: 'RON'
      end
  
      invoice.cac :InvoiceLine do |line|
        line.cbc :ID, '1'
        line.cbc :InvoicedQuantity, factura.cantitate, unitCode: 'E48'
        line.cbc :LineExtensionAmount, total_without_vat, currencyID: 'RON'
        line.cac :Item do |item|
          item.cbc :Description, "Comanda nr. #{factura.comanda_id}"
          item.cbc :Name, factura.produs
          item.cac :ClassifiedTaxCategory do |tax_category|
            tax_category.cbc :ID, 'S'
            tax_category.cbc :Percent, factura.valoare_tva
            tax_category.cac :TaxScheme do |tax_scheme|
              tax_scheme.cbc :ID, 'VAT'
            end
          end
        end
        line.cac :Price do |price|
          price.cbc :PriceAmount, factura.pret_unitar, currencyID: 'RON'
        end
      end
    end
  
    builder.target!
  end
  
  def get_country_abbreviation(country_name)
    country = Tari.find_by(nume: country_name)
    country&.abr || 'RO' # Returnează abrevierea sau 'RO' ca fallback
  end
  
  ###metoda PF final
  
  end
