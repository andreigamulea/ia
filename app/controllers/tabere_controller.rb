class TabereController < ApplicationController
  def tayv24
    data_prag = Date.new(2024, 7, 16)
    #@myvideo0 = Video.find_by(link: 'tDYGbQMGTNE') 
    @myvideo01 = "tDYGbQMGTNE"
    if current_user
      puts("User logat: #{current_user.id}")
  
      if current_user.role == 1
        # Utilizator cu role 1 are acces direct la video-uri
        @has_access = true
        valid_prods = ['cod176','cod177']
        expired_prods = []
        all_purchased = ['cod176','cod177']
        @a_cumparat_macar_un_cod = true
        @prods = Prod.none
        @prods_cumparate = Prod.where(cod: all_purchased)
      else
        # Obține codurile produselor cumpărate și datele de început și sfârșit
        purchased_prods = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
                                     .joins(:prod)
                                     .where(prods: { curslegatura: 'tayv24', status: 'activ' })
                                     .pluck('prods.cod', 'datainceput', 'datasfarsit')
  
        purchased_prods1 = ComenziProd1.where(user_id: current_user.id, validat: 'Finalizata')
                                       .joins(:prod)
                                       .where(prods: { curslegatura: 'tayv24', status: 'activ' })
                                       .pluck('prods.cod', 'datainceput', 'datasfarsit')
  
        purchased_prods ||= []
        purchased_prods1 ||= []
  
        all_purchased_prods = purchased_prods + purchased_prods1
  
        puts("Produse cumpărate cu date: #{all_purchased_prods}")
  
        valid_prods = all_purchased_prods.select { |_, datainceput, _| datainceput && datainceput + 90.days >= Date.today }.map(&:first)
        expired_prods = all_purchased_prods.select { |_, datainceput, _| datainceput && datainceput + 90.days < Date.today }.map(&:first)
  
        puts("Produse valabile: #{valid_prods}")
  
        all_purchased = all_purchased_prods.map(&:first).uniq
        @a_cumparat_macar_un_cod = all_purchased.any?
  
        if @a_cumparat_macar_un_cod
          if (all_purchased.include?('cod174') || all_purchased.include?('cod175')) && all_purchased.include?('cod178')
            @prods = Prod.none
            @has_access = true
          elsif all_purchased.include?('cod176') || all_purchased.include?('cod177')
            @has_access = true
            @prods = Prod.none
          elsif all_purchased.include?('cod174') || all_purchased.include?('cod175')
            @prods = Prod.where(cod: 'cod178')
            puts("are doar cod174 sau cod175 platit")
          else
            @prods = Prod.where(cod: ['cod176', 'cod177']).order(:id)
          end
        
        
        else
          @prods = Prod.where(cod: ['cod176', 'cod177']).order(:id)
        end
  
        @has_access ||= valid_prods.include?('cod176') || valid_prods.include?('cod177') || valid_prods.include?('cod178')
        @prods_cumparate = Prod.where(cod: all_purchased)
      end
  
      puts("Produse afișate: #{@prods.pluck(:cod) if @prods}")
      puts("Are acces? : #{@has_access}")
      puts("Produse cumpărate: #{@prods_cumparate.pluck(:cod) if @prods_cumparate}")
  
      @myvideo13 = if @a_cumparat_macar_un_cod
                     if current_user.limba == 'EN'
                       Video.where(tip: 'tayv24').where('ordine > ? AND ordine < ?', 2000, 3000).order(ordine: :asc)
                     else
                       Video.none
                     end
                   else
                     Video.none
                   end
  
      if @has_access
        @platit = true
        puts("sunt in has acces")
        if current_user.limba == 'EN'
          puts("sunt in limba en")
          @myvideo = Video.where(tip: 'tayv24').where('(ordine >= ? AND ordine <= ?)', 1000, 2000).order(ordine: :asc)
        else
          puts("NU sunt in limba en")
          @myvideo = Video.where(tip: 'tayv24').where('ordine <= ?', 1000).order(ordine: :asc)
        end
        puts("Numarul: #{@myvideo.count}")
        
      else
        puts("sunt in has acces NU")
        @myvideo13 = Video.none
      end
    else
      ## Utilizator neautentificat
      puts("User nelogat")
      @prods = Prod.where(curslegatura: 'tayv24', status: 'activ').where(cod: ['cod176', 'cod177']).order(:id)
      @has_access = false
      @prods_cumparate = Prod.none
      @videos_correspondente = Video.none
      @myvideo13 = Video.none
      @a_cumparat_macar_un_cod = false
    end
  
    if data_prag
      puts("Data prag + 90 zile= : #{data_prag + 90.days}")
    end
    if current_user && current_user.email== "kalianasundara@protonmail.com"
      @prods = Prod.where(curslegatura: 'tayv24', status: 'activ').where(cod: ['cod174', 'cod175', 'cod176', 'cod177']).order(:id)
    end  
end


def export_to_xlsx_plata_tayv24
  begin
    prod_ids = Prod.where(curslegatura: "tayv24").pluck(:id)
    mapare_valori = Prod.where(curslegatura: "tayv24").pluck(:id, :pret).to_h
    
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
