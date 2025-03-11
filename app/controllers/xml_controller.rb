require 'builder'
require 'net/http'
require 'json'
require 'uri'
require 'httparty'

class XmlController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:animaplant]

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
  
    # Generăm XML-ul (presupunem că această metodă există)
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
            id.cbc :ID, '0000000000000'
          end
          party.cac :PostalAddress do |address|
            address.cbc :StreetName, remove_diacritics(factura['adresa'].upcase)
            address.cbc :CityName, remove_diacritics(factura['oras'].upcase)
            address.cbc :CountrySubentity, "RO-#{factura['judet']}"
            address.cac :Country do |country|
              country.cbc :IdentificationCode, 'RO'
            end
          end
          party.cac :PartyTaxScheme do |tax_scheme|
            tax_scheme.cbc :CompanyID, '0000000000000'
            tax_scheme.cac :TaxScheme # Element gol
          end
          party.cac :PartyLegalEntity do |legal|
            legal.cbc :RegistrationName, factura['nume_client'].upcase
            legal.cbc :CompanyID, '0000000000000' 
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
          line.cbc :InvoicedQuantity, sprintf('%.3f', produs['Cantitate'].to_f), unitCode: 'H87'
          line.cbc :LineExtensionAmount, sprintf('%.2f', produs['Total'].to_f), currencyID: 'RON'
          line.cac :Item do |item|
            item.cbc :Name, remove_diacritics(produs['Nume'].upcase)
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

  def animaplant_api
    api_key = "KjS2IWZgx3BUdY790g3VJys9"
    start_date = params[:data_inceput]
    end_date = params[:data_sfarsit]

    if start_date.blank? || end_date.blank?
      @error_message = "Selectează o perioadă înainte de a afișa facturile."
      return render :animaplant_api
    end

    api_url = "https://animaplant.ro/wp-json/custom-api/v1/export-invoices/?api_key=#{api_key}&start_date=#{start_date}&end_date=#{end_date}"
    uri = URI(api_url)
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      @invoices = JSON.parse(response.body)
      @invoices1 = @invoices.select do |invoice|
        invoice_date = Date.parse(invoice["data_factura"]) rescue nil
        invoice_date && invoice_date >= Date.parse(start_date) && invoice_date <= Date.parse(end_date)
      end
    else
      @error_message = "Eroare la preluarea datelor: #{response.message}"
    end

    render :animaplant_api
  end
end