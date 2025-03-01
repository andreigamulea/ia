require 'builder'
require 'net/http'
require 'json'
require 'uri'
require 'httparty'

class XmlController < ApplicationController
    def animaplant
        xlsx = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'animaplant.xlsx'))
      
        @header_row = []  # Inițializează array-ul pentru primul rând (numele coloanelor)
        @second_row = []  # Inițializează array-ul pentru al doilea rând (datele facturii)
      
        row_counter = 0
      
        xlsx.each_row_streaming(offset: 0, pad_cells: true) do |row|
          if row_counter == 0
            @header_row = row.map { |cell| cell&.value ? cell.value.to_s.strip : nil }
          elsif row_counter == 23 #23 are 13 produse 34
            @second_row = row.map { |cell| cell&.value ? cell.value.to_s.strip : nil }
            break
          end
          row_counter += 1
        end    
      
        # Ajustăm dimensiunea celui de-al doilea array astfel încât să fie identică cu @header_row
        @second_row.fill(nil, @second_row.length...@header_row.length)
      
        # Calculăm numărul de produse
        @product_count = 0
        index = 107
        while index < @second_row.length
          break if @second_row[index].nil? || @second_row[index].strip.empty?
      
          @product_count += 1
          index += 6
        end
      
        # Generăm XML-ul
        @xml_output = generate_invoice_xml_individual(@header_row, @second_row, @product_count)

      
        # Dacă utilizatorul solicită descărcare, trimitem fișierul
        if params[:download] == "true"
          send_data @xml_output,
                    type: "application/xml",
                    disposition: "attachment",
                    filename: "invoice.xml"
        else
          render :animaplant
        end
      end
      
      def generate_invoice_xml_individual(header_row, invoice_data, product_count)
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
          invoice.cbc :ID, 'APFS' + (invoice_data[0] || "Unknown")
          invoice.cbc :IssueDate, invoice_data[1] || "Unknown"
          invoice.cbc :DueDate, invoice_data[1] || "Unknown"
          invoice.cbc :InvoiceTypeCode, '380'
          invoice.cbc :Note, "Nr.comanda: #{invoice_data[50] || 'Unknown'}"
          invoice.cbc :DocumentCurrencyCode, 'RON'
          invoice.cbc :TaxCurrencyCode, 'RON'
      
          invoice.cac :OrderReference do |order|
            order.cbc :ID,  "nr.#{invoice_data[50] || 'Unknown'}"
          end
          # Informații furnizor
          invoice.cac :AccountingSupplierParty do |supplier|
            supplier.cac :Party do |party|
              party.cbc :EndpointID, 'doringrasu@gmail.com', schemeID: 'EM'
              
              party.cac :PartyIdentification do |identification|
                identification.cbc :ID, '17430290'
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
          
              party.cac :PartyLegalEntity do |legal_entity|
                legal_entity.cbc :RegistrationName, 'S.C. ANIMA PLANT S.R.L.'
                legal_entity.cbc :CompanyID, 'J32/1108/2023'
                legal_entity.cbc :CompanyLegalForm, 'Capital social: 200'
              end
          
              party.cac :Contact do |contact|
                contact.cbc :Name, 'GAMULEA ANDREI FLORIN'
                contact.cbc :Telephone, '0749079619'
                contact.cbc :ElectronicMail, 'doringrasu@gmail.com'
              end
            end
          end
          
          
      
          # Informații client
          invoice.cac :AccountingCustomerParty do |customer|
            customer.cac :Party do |party|
              party.cac :PartyIdentification do |identification|
                identification.cbc :ID, invoice_data[4] || "Unknown"
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
      
          # Totaluri - fără TVA
          total_without_vat = invoice_data[6].to_f.round(2)
      
          invoice.cac :LegalMonetaryTotal do |total|
            total.cbc :LineExtensionAmount, total_without_vat, currencyID: 'RON'
            total.cbc :TaxExclusiveAmount, total_without_vat, currencyID: 'RON'
            total.cbc :TaxInclusiveAmount, total_without_vat, currencyID: 'RON'
            total.cbc :PayableAmount, total_without_vat, currencyID: 'RON'
          end
      
          # Generăm liniile de factură în funcție de `product_count`
          base_index = 107  # Prima coloană unde se află produsele
          (0...product_count).each do |i|
            index = base_index + (i * 6) # Din 6 în 6
      
            invoice.cac :InvoiceLine do |line|
              line.cbc :ID, i + 1
              line.cbc :InvoicedQuantity, '1.000', unitCode: 'H87'
              line.cbc :LineExtensionAmount, invoice_data[index + 4].to_f, currencyID: 'RON' # Preț total linie
              line.cac :Item do |item|
                item.cbc :Name, invoice_data[index] || "Unknown Product"
                item.cac :ClassifiedTaxCategory do |tax_category|
                  tax_category.cbc :ID, 'O'
                  tax_category.cac :TaxScheme do |tax_scheme|
                    tax_scheme.cbc :ID, 'VATEX-EU-O'
                  end
                end
              end
              line.cac :Price do |price|
                price.cbc :PriceAmount, invoice_data[index + 3].to_f, currencyID: 'RON' # Preț unitar
              end
            end
          end
        end
      
        builder.target!
      end

      def animaplant_api
        api_url = "https://animaplant.ro/wp-json/custom-api/v1/export-invoices/?start_date=2025-02-01&end_date=2025-02-10"
        username = "costelaioanei@yahoo.com"
        application_password = "uf89Km8dPdC7rDDu2HxEKBwa" # Înlocuiește cu parola generată
    
        response = HTTParty.get(api_url, basic_auth: { username: username, password: application_password })
    
        if response.success?
          render json: { success: true, data: response.parsed_response }
        else
          render json: { success: false, error: response.message, status: response.code }
        end
      end
      
end

  