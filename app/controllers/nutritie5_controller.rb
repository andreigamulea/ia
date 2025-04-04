class Nutritie5Controller < ApplicationController
    def index
      data_prag = Date.new(2024, 5, 19)
    
      if current_user
        puts("User logat: #{current_user.id}")
    
        if current_user.role == 1
          # Utilizator cu role 1 are acces direct la video-uri
          @has_access = true
          valid_prods = ['cod86']
          expired_prods = []
          all_purchased = ['cod86']
          @a_cumparat_macar_un_cod = true
          @prods = Prod.none
          @prods_cumparate = Prod.where(cod: all_purchased)
        else
          # Obține codurile produselor cumpărate și datele de început și sfârșit
          purchased_prods = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
                                       .joins(:prod)
                                       .where(prods: { curslegatura: 'nutritie4', status: 'activ' })
                                       .pluck('prods.cod', 'datainceput', 'datasfarsit')
    
          purchased_prods1 = ComenziProd1.where(user_id: current_user.id, validat: 'Finalizata')
                                         .joins(:prod)
                                         .where(prods: { curslegatura: 'nutritie4', status: 'activ' })
                                         .pluck('prods.cod', 'datainceput', 'datasfarsit')
    
          purchased_prods ||= []
          purchased_prods1 ||= []
    
          all_purchased_prods = purchased_prods + purchased_prods1
    
          puts("Produse cumpărate cu date: #{all_purchased_prods}")
    
          valid_prods = all_purchased_prods.select do |_, datainceput, _|
            if datainceput && datainceput < data_prag
              data_prag + 90.days >= Date.today
            else
              datainceput && datainceput + 90.days >= Date.today
            end
          end.map(&:first)
    
          expired_prods = all_purchased_prods.select do |_, datainceput, _|
            if datainceput && datainceput < data_prag
              data_prag + 90.days < Date.today
            else
              datainceput && datainceput + 90.days < Date.today
            end
          end.map(&:first)
    
          puts("Produse valabile: #{valid_prods}")
    
          all_purchased = all_purchased_prods.map(&:first).uniq
          @a_cumparat_macar_un_cod = all_purchased.any?
          @has_access = valid_prods.include?('cod86') || valid_prods.include?('cod88') || valid_prods.include?('cod89')
  
          ########################
          @condition2 = false
          special_emails_with_dates = {
            'cristina.nedescu@gmail.com' => Date.new(2026, 1, 4),
            'derynola@gmx.com' => Date.new(2026, 1, 4),
            'tirolina9@yahoo.com' => Date.new(2025, 4, 5),
            'lucianpop1@yahoo.fr' => Date.new(2026, 1, 6),
            'lenavasvari@yahoo.com' => Date.new(2026, 1, 6),
            'pnati27@yahoo.com' => Date.new(2025, 7, 6),
            'adrian.angelic.realm@gmail.com' => Date.new(2026, 1, 6)
          }
  
        # Data curentă
        data_today = Date.today
  
        # Verificare dacă utilizatorul curent are un email special și data este validă
        if special_emails_with_dates.key?(current_user.email) && data_today <= special_emails_with_dates[current_user.email]
          @condition2 = true
          @has_access = true
          
        else
          @condition2 = false
        end
  
  
        # Logica pentru produsele achiziționate
        purchased_prods = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
          .joins(:prod)
          .where(prods: { curslegatura: 'nutritie', status: 'activ' })
          .pluck('prods.cod', 'datainceput', 'datasfarsit')
  
        purchased_prods1 = ComenziProd1.where(user_id: current_user.id, validat: 'Finalizata')
          .joins(:prod)
          .where(prods: { curslegatura: 'nutritie', status: 'activ' })
          .pluck('prods.cod', 'datainceput', 'datasfarsit')
  
        valid_prods = (purchased_prods + purchased_prods1).select do |prod|
          prod_end_date = prod[2] # presupunem că 'datasfarsit' este al treilea element din array
          puts("prod_end_date=#{prod_end_date}") # Mutat în interiorul blocului
          prod_end_date && prod_end_date >= Date.today
        end.map(&:first) # preluăm doar codurile produselor valide
  
        # Setare @has_access și @condition2 în funcție de produsele valide
        unless valid_prods.empty?
          @has_access = true
          @condition2 = true
        end
  
  
          #################################
  
  
    
          # Setare @prods pe baza valorilor lui @a_cumparat_macar_un_cod și @has_access
          if !@a_cumparat_macar_un_cod
            @prods = Prod.where(cod: ['cod86']).order(:id)
          elsif @a_cumparat_macar_un_cod && !@has_access
            @prods = Prod.where(cod: ['cod88']).order(:id)
          elsif @has_access
            @prods = Prod.none
          end
    
          @prods_cumparate = Prod.where(cod: all_purchased)
        end
    
        puts("Produse afișate: #{@prods.pluck(:cod) if @prods}")
        puts("Are acces? : #{@has_access}")
        puts("Produse cumpărate: #{@prods_cumparate.pluck(:cod) if @prods_cumparate}")
  
  
  
  
  
  
  
    
        @myvideo122 = if @a_cumparat_macar_un_cod || @condition2 # 1001-2000 sunt pt video si material pdf
          Video.where(tip: 'nutritie4').where('ordine > ? AND ordine < ?', 1000, 2000).order(ordine: :asc)
        else
          Video.none
        end
        
    
        @myvideo12 = if @a_cumparat_macar_un_cod || @condition2 # 2001-3000 sunt pt video si material pdf
          if current_user.limba == 'EN'
            Video.where(tip: 'nutritie4').where('ordine > ? AND ordine < ?', 2000, 3000).order(ordine: :asc)
          else
            Video.where(tip: 'nutritie4').where('ordine > ? AND ordine < ?', 2000, 3000).order(ordine: :asc)
          end
        else
          Video.none
        end
    
        if @has_access
          @platit = true
          puts("sunt in has acces")
          if current_user.limba == 'EN'
            puts("sunt in limba en")
            @myvideo = Video.where(tip: 'nutritie4').where('(ordine >= ? AND ordine <= ?) OR (ordine > ? AND ordine < ?)', 1, 1000, 4000, 5000).order(ordine: :asc)
          else
            puts("NU sunt in limba en")
            @myvideo = Video.where(tip: 'nutritie4').where('ordine <= ?', 1000).order(ordine: :asc)
          end
          puts("Numarul: #{@myvideo.count}")
        else
          puts("sunt in has acces NU")
        end
      else
        ## Utilizator neautentificat
        puts("User nelogat")
        @prods = Prod.where(curslegatura: 'nutritie4', status: 'activ').where(cod: ['cod86']).order(:id)
        @has_access = false
        @prods_cumparate = Prod.none
        @videos_correspondente = Video.none
        @myvideo12 = Video.none
        @a_cumparat_macar_un_cod = false
      end
    
      if data_prag
        puts("Data prag + 90 zile= : #{data_prag + 90.days}")
      end
    end
    
    
    
  #####
  
    def download
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
      file_path = Rails.root.join('public', 'pdf', 'vajikarana1', File.basename(decoded_linkzip))
      
      Rails.logger.debug "Calea este: #{file_path}"
      
      if File.exist?(file_path)
        send_file file_path, type: content_type, disposition: 'attachment'
      else
        redirect_to(root_url, alert: "Fișierul nu a fost găsit.")
      end
    end
  
    def export_to_xlsx_plata_nutritie4
      begin
        prod_ids = Prod.where(curslegatura: "nutritie4").pluck(:id)
        mapare_valori = Prod.where(curslegatura: "nutritie4").pluck(:id, :pret).to_h
        
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
  
  
  
    
  end
  