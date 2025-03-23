class CursuriAyurvedaController < ApplicationController
    def ayurveda_padartha
      #ATENTIE!!!!!!!  nu este facuta valabilitatea. Trebuie vazut pana cand au valibilitate codurile cumparate
      #dupa ce fac valabilitaea pot sterge acest mesaj
      @myvideo1 = Video.find_by(link: 'QzP2bAmqbwc') #prezentare ayurveda padartha
      @myvideo = @myvideo1.link if @myvideo1
  
      @nr_luni_achitate = 0 # Valoare implicită
      @has_acces_video = 0 # Implicit, fără acces video
      data_prag = Date.new(2025, 4, 30)
      current_date = Date.today
  
      links = [
              "57y2-QyoZ5M", "AjVnUco3WKY", "Z4IURVQPE0Q", "XoUaDndHZJ0", "pNDm6swMCtQ",
              "V_zV_C-SMu0", "mDLsLNagmqA", "s11I0cT1hXc", "50LvPIU87m4", "S4C0zZW8Vvw",
              "Tu57BiFwp2s", "TZobDqACl0Q", "dTrhsNaCGjs", "-byk3qgc_A0", "SWzAE6PB3qg",
              "SWzAE6PB3qg", "yqZCP-59PYQ", "0-XBYgJhmus", "SKh6s4fYhGI"
            ]

            unique_links = links.uniq  

            # Găsește toate rândurile din Video care corespund link-urilor
            videos = Video.where(link: unique_links)

            # Transformă rezultatele într-un hash indexat după link
            videos_hash = videos.index_by(&:link)

            @video_limit = 4  # cate video apar in pagina

            # Creează o listă de obiecte Video în aceeași ordine ca links și limitează la @video_limit
            @myvideo_ayurveda_padartha = links.map { |link| videos_hash[link] }.compact.first(@video_limit)
              
      # Verificăm dacă utilizatorul are rolul 1 pentru acces complet
      if current_user&.role == 1
        @a_cumparat_macar_un_cod = true
        @myvideo_rasayana_m1 = Video.where(tip: 'rasayana1')
                                    .where('ordine >= ? AND ordine <= ?', 0, 1000)
                                    .order(ordine: :asc).to_a
        @myvideo_rasayana_m1_seminarii = Video.where(tip: 'rasayana1')
                                              .where('ordine > ? AND ordine < ?', 1000, 2000)
                                              .order(ordine: :asc).to_a
        @prods = [] ## Nu afișăm alte produse
        products = Prod.where(curslegatura: 'modul_ayurveda_padartha', cod: ['cod315', 'cod316', 'cod317'])
        @prods = products.where(cod: ['cod315',  'cod317'])
        @has_acces_video = 4
        @nr_luni_achitate = 4
      else
        products = Prod.where(curslegatura: 'modul_ayurveda_padartha', cod: ['cod315', 'cod316', 'cod317'])
    
        if current_user.nil?
          @prods = products.where(cod: ['cod315',  'cod317'])
        else
          purchased_prods = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
                                       .joins(:prod)
                                       .where(prods: { curslegatura: 'modul_ayurveda_padartha', status: 'activ' })
                                       .pluck('prods.cod')

          puts("Produsele cumparate: #{purchased_prods}")                             
    
          if purchased_prods.include?('cod317')
            @a_cumparat_macar_un_cod = true
            @a_cumparat_digital = true
            @prods = []

                        


  

            #@myvideo_ayurveda_padartha = Video.where(tip: 'modul_ayurveda_padartha')
                                        #.where('ordine >= ? AND ordine <= ?', 0, 1000)
                                        #.order(ordine: :asc).to_a
            @myvideo_ayurveda_padartha_seminarii = Video.where(tip: 'modul_ayurveda_padartha')
                                                  .where('ordine > ? AND ordine < ?', 1000, 2000)
                                                  .order(ordine: :asc).to_a
          elsif purchased_prods.include?('cod316')
            puts("sunt aici1")
            @a_cumparat_macar_un_cod = true
            @a_cumparat_digital = true
            @prods = Prod.none
            #@myvideo_ayurveda_padartha = Video.where(tip: 'modul_ayurveda_padartha')
                                        #.where('ordine >= ? AND ordine <= ?', 0, 1000)
                                        #.order(ordine: :asc).to_a
            @myvideo_ayurveda_padartha_seminarii = Video.where(tip: 'modul_ayurveda_padartha')
                                                  .where('ordine > ? AND ordine < ?', 1000, 2000)
                                                  .order(ordine: :asc).to_a
          elsif purchased_prods.include?('cod315')
            @a_cumparat_macar_un_cod = true
            @a_cumparat_digital = false
            @prods = products.where(cod: ['cod316'])
            puts("daaaaaaaaa")
            #@myvideo_ayurveda_padartha = Video.none
            @myvideo_ayurveda_padartha_seminarii = Video.none
          else
            @prods = products.where(cod: ['cod315', 'cod317'])
            #@myvideo_ayurveda_padartha = Video.none
            @myvideo_ayurveda_padartha_seminarii = Video.none
            end
          end
    
         
        end
      
      
    end    
    

    def export_to_xlsx_plata_ayurveda_padartha
      begin
        prod_ids = Prod.where(curslegatura: "modul_ayurveda_padartha").pluck(:id)
        mapare_valori = Prod.where(curslegatura: "modul_ayurveda_padartha").pluck(:id, :pret).to_h
        
        @comenzi_prod = ComenziProd.includes(:user, :prod, comanda: :adresa_comenzi)
                                   .where(prod_id: prod_ids, validat: "Finalizata")
                                   .order(:comanda_id)
        
        # Optimize querying for Detaliifacturare
        user_ids = @comenzi_prod.map(&:user_id).uniq
        detaliifacturare_hash = Detaliifacturare.where(user_id: user_ids).index_by(&:user_id)
        
        workbook = RubyXL::Workbook.new
        worksheet = workbook[0]
        
        # Headers
        headers = ['Email', 'Nume User', 'Telefon', 'Nume din factură', 'Telefon din factură', 'Data Platii', 'Valoare', 'Comandă ID', 'Nume livrare', 'Telefon livrare', 'Adresă de livrare', 'Plată prin', 'Nume Produs', 'Validat']
        headers.each_with_index { |header, index| worksheet.add_cell(0, index, header) }
    
        @comenzi_prod.each_with_index do |comanda, index|
          worksheet.add_cell(index + 1, 0, comanda.user.email)
          worksheet.add_cell(index + 1, 1, comanda.user.name)
          worksheet.add_cell(index + 1, 2, comanda.user.telefon)
          # Preiau numele din factura
          factura = Factura.find_by(comanda_id: comanda.comanda_id)
          nume_factura = "#{factura.nume} #{factura.prenume}" if factura
          worksheet.add_cell(index + 1, 3, nume_factura)
    
          # Telefon din factura
          telefon_factura = comanda.comanda&.telefon
          worksheet.add_cell(index + 1, 4, telefon_factura)
    
          worksheet.add_cell(index + 1, 5, comanda.datainceput.strftime('%d-%m-%Y')) if comanda.datainceput
          worksheet.add_cell(index + 1, 6, mapare_valori[comanda.prod_id] || 0)
          worksheet.add_cell(index + 1, 7, comanda.comanda_id)
    
          # Nume din Livrare
          adresa = comanda.comanda&.adresa_comenzi
          detaliifacturare = detaliifacturare_hash[comanda.user.id]
          nume_livrare = if adresa
                            "#{adresa.nume} #{adresa.prenume}"
                          elsif detaliifacturare
                            "#{detaliifacturare.nume} #{detaliifacturare.prenume}"
                          end
          worksheet.add_cell(index + 1, 8, nume_livrare)
        
        # Telefon din livrare
        telefon_livrare = adresa&.telefon || detaliifacturare&.telefon
        worksheet.add_cell(index + 1, 9, telefon_livrare)
        
        # Adresă de livrare
        if adresa
          prefix = adresa.adresacoincide ? "adresa de livrare este adresa de facturare: " : "adresa de livrare diferita de adresa de facturare: "
          
          parts = [prefix, adresa.tara, adresa.judet, adresa.localitate, "cod postal: #{adresa.codpostal}", adresa.strada, adresa.numar, adresa.altedate, adresa.numecompanie, adresa.cui].compact.reject(&:empty?)
          adresa_livrare = parts.join(', ')
          
        elsif detaliifacturare
          parts = [detaliifacturare.tara, detaliifacturare.judet, detaliifacturare.localitate, "cod postal: #{detaliifacturare.codpostal}", detaliifacturare.strada, detaliifacturare.numar, detaliifacturare.altedate, detaliifacturare.numecompanie, detaliifacturare.cui].compact.reject(&:empty?)
          adresa_livrare = parts.join(', ')
          
        else
          adresa_livrare = nil
        end
          
    
          worksheet.add_cell(index + 1, 10, adresa_livrare)
          worksheet.add_cell(index + 1, 11, comanda.comanda.plataprin)
          worksheet.add_cell(index + 1, 12, comanda.prod.nume)
          worksheet.add_cell(index + 1, 13, comanda.validat)
        end
        
        file_path = Rails.root.join('tmp', "comenzi_prod_#{Time.now.to_i}.xlsx")
        workbook.write(file_path)
        send_file(file_path)
      ensure
        # Cleanup the temporary file
        #File.delete(file_path) if File.exist?(file_path)
      end
    rescue => e
      # Handle any exception and possibly notify the user or log the error
      logger.error "Error generating Excel: #{e.message}"
      redirect_to root_path, alert: "There was an error generating the report. Please try again later."
    end


    def download2
      linkzip = params[:linkzip]
      Rails.logger.debug "Parametrul linkzip este: #{linkzip}"
      decoded_linkzip = URI.decode_www_form_component(linkzip)
    
      # Determină tipul fișierului și setează tipul MIME corespunzător
      file_extension = File.extname(decoded_linkzip).downcase
      content_type = case file_extension
                     when ".rar"
                       'application/rar'
                     when ".7z"
                       'application/x-7z-compressed'
                     when ".pdf"
                       'application/pdf'
                     else
                       'application/octet-stream' # Tip generic, pentru cazul în care extensia fișierului nu este recunoscută
                     end
      
      # Construiește calea corectă
      file_path = Rails.root.join('public', 'pdf', 'ayurveda_padartha', File.basename(decoded_linkzip))
      
      Rails.logger.debug "Calea este: #{file_path}"
      
      if File.exist?(file_path)
        send_file file_path, type: content_type, disposition: 'attachment'
      else
        redirect_to(root_url, alert: "Fișierul nu a fost găsit.")
      end
    end

  end
  