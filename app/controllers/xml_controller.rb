require 'builder'
require 'net/http'
require 'json'
require 'uri'
require 'httparty'

class XmlController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:animaplant, :proxy_pdf]

  def animaplant
    numar_comanda = params[:numar_comanda]
    facturi_json = params[:facturi_json]
  
    # Verificăm dacă facturi_json este valid
    unless facturi_json.is_a?(Array)
      render json: { error: "facturi_json nu este valid" }, status: :unprocessable_entity
      return
    end
  
    # Găsim factura
    factura_selectata = facturi_json.find { |factura| factura["numar_comanda"] == numar_comanda }
    if factura_selectata.nil?
      render json: { error: "Factura nu a fost găsită" }, status: :not_found
      return
    end
  
    # Verificăm datele necesare
    unless factura_selectata["numar_factura"] && factura_selectata["data_factura"]
      render json: { error: "Datele facturii sunt incomplete" }, status: :unprocessable_entity
      return
    end
  
    # Generăm XML-ul
    xml_output = generate_invoice_xml_individual(factura_selectata)
  
    # Construim numele fișierului
    cod_furnizor = "17430290"
    prefix_factura = "APFS"
    numar_factura = factura_selectata["numar_factura"]
    data_factura = factura_selectata["data_factura"]
  
    # Gestionăm formatul datei
    begin
      data_formatata = Date.parse(data_factura).strftime("%d-%m-%Y")
    rescue ArgumentError
      render json: { error: "Data facturii este invalidă" }, status: :unprocessable_entity
      return
    end
  
    nume_fisier = "F_#{cod_furnizor}_#{prefix_factura}#{numar_factura}_#{data_formatata}.xml"
  
    # Returnăm un răspuns JSON
    render json: {
      xml: xml_output,
      filename: nume_fisier
    }
  end

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
      # Header-ul facturii
      invoice.cbc :UBLVersionID, '2.1'
      invoice.cbc :CustomizationID, 'urn:cen.eu:en16931:2017#compliant#urn:efactura.mfinante.ro:CIUS-RO:1.0.1'
      invoice.cbc :ID, "APFS#{factura['numar_factura']}"
      invoice.cbc :IssueDate, factura['data_factura']
      invoice.cbc :DueDate, factura['data_factura']
      invoice.cbc :InvoiceTypeCode, '380'
      invoice.cbc :Note, "Comanda nr.#{factura['numar_comanda']}"
      invoice.cbc :DocumentCurrencyCode, 'RON'
      invoice.cbc :TaxCurrencyCode, 'RON'
  
      # Referință la comandă
      invoice.cac :OrderReference do |order|
        order.cbc :ID, "nr.#{factura['numar_comanda']}"
      end
  
      # Furnizor
      invoice.cac :AccountingSupplierParty do |supplier|
        supplier.cac :Party do |party|
          party.cbc :EndpointID, 'doringrasu@gmail.com', schemeID: 'EM'
          party.cac :PartyIdentification do |id|
            id.cbc :ID, '17430290'
          end
          party.cac :PostalAddress do |address|
            address.cbc :StreetName, 'CIRTISOARA nr. 317'
            address.cbc :CityName, 'COMUNA CARTISOARA'
            address.cbc :CountrySubentity, 'RO-SB'
            address.cac :Country do |country|
              country.cbc :IdentificationCode, 'RO'
            end
          end
          party.cac :PartyTaxScheme do |tax_scheme|
            tax_scheme.cbc :CompanyID, '17430290'
            tax_scheme.cac :TaxScheme # Element gol
          end
          party.cac :PartyLegalEntity do |legal|
            legal.cbc :RegistrationName, 'S.C. ANIMA PLANT S.R.L.'
            legal.cbc :CompanyID, 'J32/1108/2023'
            legal.cbc :CompanyLegalForm, 'Capital social: 200'
          end
          party.cac :Contact do |contact|
            contact.cbc :Name, 'GAMULEA ANDREI FLORIN'
            contact.cbc :Telephone, '0749079619'
            contact.cbc :ElectronicMail, 'doringrasu@gmail.com'
          end
        end
      end
  
      # Client
      invoice.cac :AccountingCustomerParty do |customer|
        customer.cac :Party do |party|
          party.cac :PartyIdentification do |id|
            id.cbc :ID, '0000000000000' # Fixat la 0000000000000 pentru toate cazurile
          end
          party.cac :PostalAddress do |address|
            address.cbc :StreetName, remove_diacritics(factura['adresa'].upcase)
            address.cbc :CityName, replace_bucharest_sectors(remove_diacritics(factura['oras'].upcase))
            address.cbc :CountrySubentity, "RO-#{factura['judet']}"
            address.cac :Country do |country|
              country.cbc :IdentificationCode, 'RO'
            end
          end
          # Verificăm dacă CUI este valid pentru PJ: [A-Z]+\d+ sau doar cifre (nu doar zerouri), excluzând "-"
          is_legal_entity = factura['CUI'] && factura['CUI'] != '-' && factura['CUI'] != 'N/A' && factura['CUI'] !~ /^0+$/ && (factura['CUI'].gsub(/[^0-9]/, '').chars.uniq.reject { |c| c == '0' }.size >= 3)
          party.cac :PartyTaxScheme do |tax_scheme|
            tax_scheme.cbc :CompanyID, is_legal_entity ? factura['CUI'] : '0000000000000'
            tax_scheme.cac :TaxScheme # Element gol
          end
          party.cac :PartyLegalEntity do |legal|
            legal.cbc :RegistrationName, is_legal_entity ? remove_diacritics(factura['companie'].upcase) : remove_diacritics(factura['nume_client'].upcase)
            legal.cbc :CompanyID, is_legal_entity ? factura['CUI'] : '0000000000000'
          end
          party.cac :Contact do |contact|
            contact.cbc :Name, remove_diacritics(factura['nume_client'].upcase)
            contact.cbc :Telephone, factura['telefon']
            contact.cbc :ElectronicMail, factura['email']
          end
        end
      end
  
      # Metoda de plată
      invoice.cac :PaymentMeans do |payment|
        payment.cbc :PaymentMeansCode, '42'
        payment.cac :PayeeFinancialAccount do |account|
          account.cbc :ID, 'RO15INGB0000999902898225'
          account.cbc :Name, 'ING BANK ROMANIA'
        end
      end
  
      # Totaluri TVA
      invoice.cac :TaxTotal do |tax_total|
        tax_total.cbc :TaxAmount, '0.00', currencyID: 'RON'
        tax_total.cac :TaxSubtotal do |subtotal|
          subtotal.cbc :TaxableAmount, sprintf('%.2f', factura['total'].to_f), currencyID: 'RON'
          subtotal.cbc :TaxAmount, '0.00', currencyID: 'RON'
          subtotal.cac :TaxCategory do |category|
            category.cbc :ID, 'O'
            category.cbc :TaxExemptionReasonCode, 'VATEX-EU-O'
            category.cbc :TaxExemptionReason, 'Entitatea nu este inregistrata in scopuri de TVA'
            category.cac :TaxScheme do |scheme|
              scheme.cbc :ID, 'VAT'
            end
          end
        end
      end
  
      # Totaluri monetare
      invoice.cac :LegalMonetaryTotal do |total|
        total.cbc :LineExtensionAmount, sprintf('%.2f', factura['total'].to_f), currencyID: 'RON'
        total.cbc :TaxExclusiveAmount, sprintf('%.2f', factura['total'].to_f), currencyID: 'RON'
        total.cbc :TaxInclusiveAmount, sprintf('%.2f', factura['total'].to_f), currencyID: 'RON'
        total.cbc :PayableAmount, sprintf('%.2f', factura['total'].to_f), currencyID: 'RON'
      end
  
      # Linii de factură
      factura['produse'].each_with_index do |produs, i|
        invoice.cac :InvoiceLine do |line|
          line.cbc :ID, i + 1
          unit_code = produs['Nume'].downcase.include?('transport') ? 'E48' : 'H87'
          line.cbc :InvoicedQuantity, sprintf('%.3f', produs['Cantitate'].to_f), unitCode: unit_code
          line.cbc :LineExtensionAmount, sprintf('%.2f', produs['Total'].to_f), currencyID: 'RON'
          line.cac :Item do |item|
            product_name = produs['Nume'].upcase.gsub(' + ', '+')
            product_name = 'CARGUS NATIONAL' if product_name == 'TRANSPORT'
            item.cbc :Name, remove_diacritics(product_name)
            item.cac :ClassifiedTaxCategory do |tax|
              tax.cbc :ID, 'O'
              tax.cac :TaxScheme do |scheme|
                scheme.cbc :ID, 'VAT'
              end
            end
          end
          line.cac :Price do |price|
            price.cbc :PriceAmount, sprintf('%.4f', produs['Pret Unitar'].to_f), currencyID: 'RON'
          end
        end
      end
    end
    builder.target!
  end

  def remove_diacritics(text)
    return text unless text.is_a?(String)
    text.tr(
      "ăâîșțĂÂÎȘȚ",
      "aaistAAIST"
    )
  end

  def replace_bucharest_sectors(text)
    return text unless text.is_a?(String)
    case text
    when "S1"
      "BUCURESTI SECTOR 1"
    when "S2"
      "BUCURESTI SECTOR 2"
    when "S3"
      "BUCURESTI SECTOR 3"
    when "S4"
      "BUCURESTI SECTOR 4"
    when "S5"
      "BUCURESTI SECTOR 5"
    when "S6"
      "BUCURESTI SECTOR 6"
    else
      text
    end
  end
  
  def animaplant_api
    api_key = "KjS2IWZgx3BUdY790g3VJys9"
    start_date = params[:data_inceput]
    end_date = params[:data_sfarsit]
  
    if start_date.blank? || end_date.blank?
      @error_message = "Selectează o perioadă înainte de a afișa facturile."
      return render :animaplant_api
    end
  
    begin
      start_date_parsed = Date.parse(start_date)
      end_date_parsed = Date.parse(end_date)
      Rails.logger.info("Parsed start_date: #{start_date}, end_date: #{end_date}")
    rescue ArgumentError
      @error_message = "Datele introduse nu sunt valide. Folosește formatul YYYY-MM-DD."
      return render :animaplant_api
    end
  
    uri = URI.parse("https://animaplant.ro/wp-json/custom-api/v1/export-invoices/")
    uri.query = URI.encode_www_form(api_key: api_key, start_date: start_date, end_date: end_date)
  
    Rails.logger.info("Calling API: #{uri.to_s}")
    begin
      response = Net::HTTP.get_response(uri)
      Rails.logger.info("API response code: #{response.code}")
    rescue StandardError => e
      @error_message = "Eroare de conexiune: #{e.message}"
      Rails.logger.error("API connection error: #{e.message}")
      return render :animaplant_api
    end
  
    if response.is_a?(Net::HTTPSuccess)
      Rails.logger.info("API raw response: #{response.body}")
      begin
        # Extragem doar partea JSON din răspuns
        json_start = response.body.index('[{') # Găsim începutul JSON-ului
        if json_start
          json_data = response.body[json_start..-1] # Luăm de la '[{' până la sfârșit
          @invoices = JSON.parse(json_data)
          Rails.logger.info("API response parsed, invoices count: #{@invoices.size}")
          @invoices1 = @invoices.select do |invoice|
            invoice_date = Date.parse(invoice["data_factura"]) rescue nil
            invoice_date && invoice_date >= start_date_parsed && invoice_date <= end_date_parsed
          end
          Rails.logger.info("Filtered invoices count: #{@invoices1.size}")
        else
          @error_message = "Nu s-a găsit JSON valid în răspunsul API."
          Rails.logger.error("No valid JSON found in API response")
        end
      rescue JSON::ParserError => e
        @error_message = "Eroare la parsarea JSON-ului: #{e.message}"
        Rails.logger.error("JSON parse error: #{e.message}")
      end
    else
      @error_message = "Eroare API: #{response.code} - #{response.message}"
      Rails.logger.error("API error: #{response.code} - #{response.message}")
    end
  
    render :animaplant_api
  end

  def proxy_pdf
    id_comanda = params[:id_comanda] # Aici primim numar_comanda (ex. 3348)
    api_key = "KjS2IWZgx3BUdY790g3VJys9"
    prefix_fisier = "F_17430290_APFS"
  
    Rails.logger.info "ID comandă primit: #{id_comanda}"
  
    # Obținem datele facturii din API
    api_url = "https://animaplant.ro/wp-json/custom-api/v1/export-invoices/?api_key=#{api_key}&start_date=2020-01-01&end_date=#{Date.today.strftime('%Y-%m-%d')}"
    begin
      response_invoices = HTTParty.get(api_url)
    rescue StandardError => e
      Rails.logger.error "Eroare la apelarea API: #{e.message}"
      render plain: "Eroare la apelarea API: #{e.message}", status: :internal_server_error
      return
    end
  
    if response_invoices.success?
      begin
        # Extragem JSON-ul din răspuns
        json_start = response_invoices.body.index('[{')
        if json_start
          json_data = response_invoices.body[json_start..-1]
          facturi_json = JSON.parse(json_data)
          Rails.logger.info "Număr facturi găsite: #{facturi_json.length}"
  
          # Căutăm factura după numar_comanda
          factura_selectata = facturi_json.find { |factura| factura["numar_comanda"] == id_comanda }
  
          if factura_selectata.nil?
            Rails.logger.error "Factura cu numar_comanda #{id_comanda} nu a fost găsită"
            render plain: "Factura cu numar_comanda #{id_comanda} nu a fost găsită", status: :not_found
            return
          else
            Rails.logger.info "Factura găsită: #{factura_selectata.inspect}"
            numar_factura = factura_selectata["numar_factura"]
            data_factura = factura_selectata["data_factura"]
            document_id = factura_selectata["id_comanda"] # Extragem id_comanda (ex. 7484)
  
            unless numar_factura && data_factura
              Rails.logger.error "Datele facturii sunt incomplete - numar_factura: #{numar_factura}, data_factura: #{data_factura}"
              render plain: "Datele facturii sunt incomplete", status: :internal_server_error
              return
            else
              begin
                data_formatata = Date.parse(data_factura).strftime("%d-%m-%Y")
                nume_fisier = "#{prefix_fisier}#{numar_factura}_#{data_formatata}.pdf"
                Rails.logger.info "Nume fișier generat: #{nume_fisier}"
              rescue ArgumentError => e
                Rails.logger.error "Eroare la parsarea datei: #{e.message}"
                render plain: "Eroare la parsarea datei: #{e.message}", status: :internal_server_error
                return
              end
            end
          end
        else
          Rails.logger.error "Nu s-a găsit JSON valid în răspunsul API"
          render plain: "Nu s-a găsit JSON valid în răspunsul API", status: :internal_server_error
          return
        end
      rescue JSON::ParserError => e
        Rails.logger.error "Eroare la parsarea JSON: #{e.message}"
        render plain: "Eroare la parsarea JSON: #{e.message}", status: :internal_server_error
        return
      end
    else
      Rails.logger.error "Eroare API: #{response_invoices.code} - #{response_invoices.message}"
      render plain: "Eroare API: #{response_invoices.code} - #{response_invoices.message}", status: response_invoices.code
      return
    end
  
    # Construim URL-ul cu document_id corect (id_comanda)
    pdf_url = "https://animaplant.ro/wp-json/custom-api/v1/export-invoice-to-pdf/?document_id=#{document_id}&api_key=#{api_key}"
    Rails.logger.info "URL PDF: #{pdf_url}"
  
    begin
      response = HTTParty.get(pdf_url,
        headers: {
          'Accept' => 'application/pdf',
          'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        },
        follow_redirects: true,
        timeout: 30
      )
  
      # Verificăm Content-Type
      content_type = response.headers['content-type']
      Rails.logger.info "Content-Type al răspunsului PDF: #{content_type}"
      Rails.logger.info "Răspuns brut PDF (primele 100 caractere): #{response.body[0..100].force_encoding('ASCII-8BIT').inspect}"
  
      # Dacă Content-Type nu este application/pdf, încercăm să extragem PDF-ul din răspuns
      if content_type&.include?('application/pdf')
        # Răspunsul este un PDF pur
        pdf_data = response.body
      else
        # Răspunsul conține HTML/JavaScript + PDF
        pdf_start = response.body.index('%PDF')
        if pdf_start
          pdf_data = response.body[pdf_start..-1]
          Rails.logger.info "PDF extras din răspuns, lungime: #{pdf_data.length} octeți"
        else
          Rails.logger.error "Nu s-a găsit un PDF valid în răspuns. Body: #{response.body[0..100].force_encoding('ASCII-8BIT')}"
          render plain: "Eroare: Nu s-a găsit un PDF valid în răspunsul API. Code: #{response.code}, Content-Type: #{content_type}", status: :internal_server_error
          return
        end
      end
  
      # Forțăm codarea binară pentru a evita erorile UTF-8
      pdf_data = pdf_data.dup.force_encoding('ASCII-8BIT')
  
      # Verificăm dacă PDF-ul este valid (începe cu %PDF și se termină cu %%EOF)
      unless pdf_data.start_with?("%PDF")
        Rails.logger.error "Răspunsul nu este un PDF valid (nu începe cu %PDF). Body: #{pdf_data[0..100].inspect}"
        render plain: "Răspunsul de la API nu este un PDF valid (nu începe cu %PDF)", status: :internal_server_error
        return
      end
  
      unless pdf_data.rstrip.end_with?("%%EOF")
        Rails.logger.error "Răspunsul nu este un PDF valid (nu se termină cu %%EOF). Body (ultimele 100 caractere): #{pdf_data[-100..-1].inspect}"
        render plain: "Răspunsul de la API nu este un PDF valid (nu se termină cu %%EOF)", status: :internal_server_error
        return
      end
  
      send_data pdf_data,
                filename: nume_fisier,
                type: 'application/pdf',
                disposition: 'attachment'
      return # Asigurăm că nu mai randează altceva după send_data
    rescue StandardError => e
      Rails.logger.error "Eroare la proxy: #{e.message}"
      render plain: "Eroare la proxy: #{e.message}", status: :internal_server_error
      return
    end
  end
end