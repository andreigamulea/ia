class FacturasController < ApplicationController 
  require 'zip'
  require 'builder'
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
    @facturas = Factura.order(created_at: :asc)
    @facturas_pe_firma = @facturas.select { |factura| factura.cui =~ /\d{2,}/ }
  end

  def download_xml
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

      # Verifică dacă există date în tabela date_facturare
      date_facturare_record = DateFacturare.find_by(user_id: user_id)
      an_curs = if date_facturare_record
                  date_facturare_record.grupa2324
                else
                  user_record = User.find_by(id: user_id)
                  user_record ? user_record.grupa : '-'
                end

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
          an_curs: an_curs
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
    # Crearea unui folder temporar pentru stocarea PDF-urilor
    temp_folder = Rails.root.join('tmp', 'pdfs')
    FileUtils.mkdir_p(temp_folder)
    
    ##Extrageți facturile pe care doriți să le includeți
    #facturas = Factura.where(numar: 1204..1542)#octombrie
    #facturas = Factura.where(numar: 1536..1654)#noiembrie
    #facturas = Factura.where(numar: 1649..1716)#decembrie
    #facturas = Factura.where(numar: 1713..1782)#ianuarie
    #facturas = Factura.where(numar: 1780..1922)#februarie
    #facturas = Factura.where(numar: 1918..2037)#martie
    #facturas = Factura.where(numar: 2035..2118)#aprilie
    facturas = Factura.where(numar: 2118..2250)#amai
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
    
    
    def generate_invoice_xml(factura)
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
            if factura.cui =~ /\d{2,}/
              party.cac :PartyIdentification do |identification|
                identification.cbc :ID, factura.cui
              end
              party.cac :PartyLegalEntity do |legal_entity|
                legal_entity.cbc :RegistrationName, factura.nume_companie if factura.nume_companie.present?
                legal_entity.cbc :CompanyID, factura.cui
              end
            else
              party.cac :PartyName do |party_name|
                party_name.cbc :Name, "#{factura.nume} #{factura.prenume}"
              end
            end
            party.cac :PostalAddress do |address|
              address.cbc :StreetName, "#{factura.strada}, NR. #{factura.numar_adresa}"
              address.cbc :CityName, factura.localitate
              address.cbc :CountrySubentity, "RO-#{factura.judet}"
              address.cac :Country do |country|
                country.cbc :IdentificationCode, 'RO'
              end
            end
            if factura.cui =~ /\d{2,}/
              party.cac :PartyTaxScheme do |tax_scheme|
                tax_scheme.cbc :CompanyID, factura.cui
                tax_scheme.cac :TaxScheme do |tax|
                  tax.cbc :ID, 'VAT'
                end
              end
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
  
        total_without_vat = factura.pret_unitar * factura.cantitate
        vat_amount = (total_without_vat * (factura.valoare_tva / 100)).round(2)
        total_with_vat = (total_without_vat + vat_amount).round(2)
  
        invoice.cac :TaxTotal do |tax_total|
          tax_total.cbc :TaxAmount, vat_amount, currencyID: 'RON'
          tax_total.cac :TaxSubtotal do |tax_subtotal|
            tax_subtotal.cbc :TaxableAmount, total_without_vat, currencyID: 'RON'
            tax_subtotal.cbc :TaxAmount, vat_amount, currencyID: 'RON'
            tax_subtotal.cac :TaxCategory do |tax_category|
              tax_category.cbc :ID, 'S'
              tax_category.cbc :Percent, factura.valoare_tva
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
    ### metoda PJ start
    def generate_invoice_xml_company(factura)
      builder = Builder::XmlMarkup.new(indent: 2)
      builder.Facturi do |facturi|
        facturi.Factura do |factura_xml|
          factura_xml.Antet do |antet|
            antet.FurnizorNume 'S.C. AYUSH CELL ROMANIA S.R.L.'
            antet.FurnizorCIF 'RO5509227'
            antet.FurnizorNrRegCom 'J40/6720/1994'
            antet.FurnizorCapital '205.00'
            antet.FurnizorAdresa 'BUCURESTI sect. 1 str. OSTASILOR nr. 15 ap. 1A'
            antet.FurnizorBanca 'CEC BANK SA'
            antet.FurnizorIBAN 'RO49CECEB20701RON0591530'
            antet.FurnizorInformatiiSuplimentare 'Banca ING BANK IBAN RO53INGB0000999902918784'
            antet.ClientNume factura.nume_companie
            antet.ClientInformatiiSuplimentare ''
            antet.ClientCIF factura.cui
            antet.ClientNrRegCom ''
            antet.ClientJudet factura.judet
            antet.ClientLocalitate factura.localitate
            antet.ClientTara 'RO'
            antet.ClientAdresa "#{factura.localitate}, STR. #{factura.strada}, NR. #{factura.numar_adresa}"
            antet.ClientTelefon ''
            antet.ClientEmail ''
            antet.ClientBanca ''
            antet.ClientIBAN ''
            antet.FacturaNumar "ACDA#{factura.numar}"
            antet.FacturaData factura.created_at.strftime('%d.%m.%Y')
            antet.FacturaScadenta factura.created_at.strftime('%d.%m.%Y')
            antet.FacturaTaxareInversa 'Nu'
            antet.FacturaTVAIncasare 'Da'
            antet.FacturaEFactura 'Nu'
            antet.FacturaInformatiiSuplimentare ''
            antet.FacturaMoneda 'RON'
            antet.FacturaCotaTVA 'TVA (19%)'
            antet.FacturaGreutate '0.000'
            antet.FacturaAccize '0.00'
          end
    
          factura_xml.Detalii do |detalii|
            detalii.Continut do |continut|
              continut.Linie do |linie|
                linie.LinieNrCrt '1'
                linie.Descriere factura.produs
                linie.CodArticolFurnizor ''
                linie.CodArticolClient ''
                linie.InformatiiSuplimentare ''
                linie.UM ''
                linie.Cantitate factura.cantitate
                linie.Pret factura.pret_unitar.round(2)
                linie.Valoare (factura.pret_unitar * factura.cantitate).round(2)
                linie.ProcTVA factura.valoare_tva
                linie.TVA ((factura.pret_unitar * factura.cantitate) * (factura.valoare_tva / 100)).round(2)
              end
            end
            detalii.txtObservatii1 "Nr.comanda: #{factura.comanda_id}"
          end
    
          factura_xml.Sumar do |sumar|
            total_valoare = (factura.pret_unitar * factura.cantitate).round(2)
            total_tva = (total_valoare * (factura.valoare_tva / 100)).round(2)
            total = (total_valoare + total_tva).round(2)
    
            sumar.TotalValoare total_valoare
            sumar.TotalTVA total_tva
            sumar.Total total
            sumar.LinkPlata ''
          end
    
          factura_xml.Observatii do |observatii|
            observatii.txtObservatii ''
            observatii.SoldClient ''
            observatii.ModalitatePlata ''
          end
        end
      end
    
      builder.target!
    end
    
    ###metoda PJ final
  
  ###metoda PF start
  def generate_invoice_xml_individual(factura)
    builder = Builder::XmlMarkup.new(indent: 2)
    builder.Facturi do |facturi|
      facturi.Factura do |factura_xml|
        factura_xml.Antet do |antet|
          antet.FurnizorNume 'S.C. AYUSH CELL ROMANIA S.R.L.'
          antet.FurnizorCIF 'RO5509227'
          antet.FurnizorNrRegCom 'J40/6720/1994'
          antet.FurnizorCapital '205.00'
          antet.FurnizorAdresa 'BUCURESTI sect. 1 str. OSTASILOR nr. 15 ap. 1A'
          antet.FurnizorBanca 'CEC BANK SA'
          antet.FurnizorIBAN 'RO49CECEB20701RON0591530'
          antet.FurnizorInformatiiSuplimentare 'Banca ING BANK IBAN RO53INGB0000999902918784'
          antet.ClientNume "#{factura.nume} #{factura.prenume}"
          antet.ClientInformatiiSuplimentare ''
          antet.ClientCIF ''
          antet.ClientNrRegCom ''
          antet.ClientJudet factura.judet
          antet.ClientLocalitate factura.localitate
          antet.ClientTara 'RO'
          antet.ClientAdresa "#{factura.localitate}, STR. #{factura.strada}, NR. #{factura.numar_adresa}"
          antet.ClientTelefon ''
          antet.ClientEmail ''
          antet.ClientBanca ''
          antet.ClientIBAN ''
          antet.FacturaNumar "ACDA#{factura.numar}"
          antet.FacturaData factura.created_at.strftime('%d.%m.%Y')
          antet.FacturaScadenta factura.created_at.strftime('%d.%m.%Y')
          antet.FacturaTaxareInversa 'Nu'
          antet.FacturaTVAIncasare 'Da'
          antet.FacturaEFactura 'Nu'
          antet.FacturaInformatiiSuplimentare ''
          antet.FacturaMoneda 'RON'
          antet.FacturaCotaTVA 'TVA (19%)'
          antet.FacturaGreutate '0.000'
          antet.FacturaAccize '0.00'
        end
  
        factura_xml.Detalii do |detalii|
          detalii.Continut do |continut|
            continut.Linie do |linie|
              linie.LinieNrCrt '1'
              linie.Descriere factura.produs
              linie.CodArticolFurnizor ''
              linie.CodArticolClient ''
              linie.InformatiiSuplimentare ''
              linie.UM 'SERV'
              linie.Cantitate factura.cantitate
              linie.Pret factura.pret_unitar.round(2)
              linie.Valoare (factura.pret_unitar * factura.cantitate).round(2)
              linie.ProcTVA factura.valoare_tva
              linie.TVA ((factura.pret_unitar * factura.cantitate) * (factura.valoare_tva / 100)).round(2)
              linie.InformatiiSuplimentare "Comanda nr. #{factura.comanda_id}"
            end
          end
          detalii.txtObservatii1 "Nr.comanda: #{factura.comanda_id}"
        end
  
        factura_xml.Sumar do |sumar|
          total_valoare = (factura.pret_unitar * factura.cantitate).round(2)
          total_tva = (total_valoare * (factura.valoare_tva / 100)).round(2)
          total = (total_valoare + total_tva).round(2)
  
          sumar.TotalValoare total_valoare
          sumar.TotalTVA total_tva
          sumar.Total total
          sumar.LinkPlata ''
        end
  
        factura_xml.Observatii do |observatii|
          observatii.txtObservatii ''
          observatii.SoldClient ''
          observatii.ModalitatePlata ''
        end
      end
    end
  
    builder.target!
  end
  
  ###metoda PF final
  
  end
