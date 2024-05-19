class PaginisitesController < ApplicationController
  before_action :set_paginisite, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: %i[index userilogati useriunici_logati export_to_xlsx] #verifica daca utilizatorul este autentificat
  before_action :set_user, only: %i[index userilogati useriunici_logati export_to_xlsx]
  before_action :set_user_admin, only: %i[index new show edit update destroy statistici_utilizator export_to_xlsx_no_login 
  export_to_xlsx_plata_nutritie3 export_to_xlsx_plata_an1 export_to_xlsx_summary export_to_xlsx_plata_tayv2 export_to_xlsx_plata_tayt12
  export_to_xlsx_plata_vajikarana_modul1]
  # GET /paginisites or /paginisites.json
  def index
    @paginisites = Paginisite.all
  end

  # GET /paginisites/1 or /paginisites/1.json
  def show
  end

  # GET /paginisites/new
  def new
    @paginisite = Paginisite.new
  end

  # GET /paginisites/1/edit
  def edit
  end

  # POST /paginisites or /paginisites.json
  def create
    @paginisite = Paginisite.new(paginisite_params)

    respond_to do |format|
      if @paginisite.save
        format.html { redirect_to paginisite_url(@paginisite), notice: "Paginisite was successfully created." }
        format.json { render :show, status: :created, location: @paginisite }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @paginisite.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /paginisites/1 or /paginisites/1.json
  def update
    respond_to do |format|
      if @paginisite.update(paginisite_params)
        format.html { redirect_to paginisite_url(@paginisite), notice: "Paginisite was successfully updated." }
        format.json { render :show, status: :ok, location: @paginisite }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @paginisite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /paginisites/1 or /paginisites/1.json
  def destroy
    @paginisite.destroy

    respond_to do |format|
      format.html { redirect_to paginisites_url, notice: "Paginisite was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  def userilogati
    search_term = params[:search]
    @q = UserPaginisite.includes(:user, :paginisite).where(paginisites: { nume: 'Login' }).ransack(
      user_email_cont: search_term, 
      user_name_cont: search_term, 
      m: 'or'
    )
    @user_paginisite = @q.result.order('user_paginisites.created_at DESC').page(params[:page]).per(15)
  end
  
  
  def useriunici_logati
    search_term = params[:search]
      
    # Subquery to get the max created_at for each user_id
    subquery = UserPaginisite.group(:user_id).select('user_id, MAX(created_at) as max_created_at')
      
    # Query to get count of visits for each user
    @visit_counts = UserPaginisite.group(:user_id).count
  
    # Main query to get the UserPaginisite records where each user_id has the latest created_at
    @q = UserPaginisite.joins("INNER JOIN (#{subquery.to_sql}) sub ON user_paginisites.user_id = sub.user_id AND user_paginisites.created_at = sub.max_created_at")
                         .includes(:user, :paginisite)
                         .where(paginisites: { nume: 'Login' })
                         .ransack(
                           user_email_cont: search_term, 
                           user_name_cont: search_term, 
                           m: 'or'
                         )
    
    @user_paginisite = @q.result.order('user_paginisites.created_at DESC').page(params[:page]).per(15)
  end
  def statistici_utilizator
    user_id = params[:id]
    @user_name = params[:user_name]
    @user_page_visit_times_by_date = Ahoy::Event
      .where(user_id: user_id) # Aici am făcut modificarea
      .where("properties ->> 'page' = '/valori-nutritionale'")
      .order(:time)
      .group_by { |event| event.time.to_date }
      .transform_values do |events_on_same_date|
        events_on_same_date.group_by { |event| event.properties["page"] }
          .transform_values do |events_on_same_page|
            total_time = 0
            load_event = nil
  
            events_on_same_page.each do |event|
              if event.name == "$page_load"
                load_event = event
              elsif event.name == "$page_unload" && load_event
                total_seconds = (event.time.to_i - load_event.time.to_i).abs
                if load_event.time.to_date < event.time.to_date
                  total_seconds = (event.time.beginning_of_day - load_event.time).abs.to_i
                end
                minutes = total_seconds / 60
                seconds = total_seconds % 60
                total_time += minutes * 60 + seconds
                load_event = nil
              end
            end
            total_time
          end
      end


      @user_browsers = Ahoy::Visit.where(user_id: user_id).pluck(:browser).uniq
      
      @user_platforms = Ahoy::Visit.where(user_id: user_id).pluck(:device_type).uniq

      @user_os = Ahoy::Visit.where(user_id: user_id).pluck(:os).uniq

  #@user_page_visit_times_by_date = Ahoy::Event
  #.where(user_id: user_id)
  #.group_by { |event| event.time.to_date }
  #.transform_values do |events_on_same_date|
   # events_on_same_date.group_by { |event| event.properties["page"] }
      #.transform_values do |events_on_same_page|
        #load_events = events_on_same_page.select { |event| event.name == "$page_load" }
        #unload_events = events_on_same_page.select { |event| event.name == "$page_unload" }

        #total_time = 0
        #load_events.zip(unload_events).each do |load_event, unload_event|
          #if load_event && unload_event
            # Conversia în minute și secunde
            #total_seconds = (unload_event.time - load_event.time)
            #minutes = total_seconds / 60
            #seconds = total_seconds % 60
            #total_time += minutes * 60 + seconds
          #end
        #end
        #total_time
      #end
  #end


    
      @valori_nutritionale_page_visit_times_by_date = @user_page_visit_times_by_date.transform_values do |pages|
        total_seconds = pages["/valori-nutritionale"] || 0
        minutes = total_seconds / 60
        hours = minutes / 60
        minutes = minutes % 60
        seconds = total_seconds % 60
        "#{minutes} minute, #{seconds} secunde"
      end
      
    end
  
  def export_to_xlsx # export in xlsx lista utilizatori care s-au logat macar odata 
    search_term = params[:search]

    # Subquery to get the max created_at for each user_id
    subquery = UserPaginisite.group(:user_id).select('user_id, MAX(created_at) as max_created_at')
  
    # Main query to get the UserPaginisite records where each user_id has the latest created_at
    @q = UserPaginisite.joins("INNER JOIN (#{subquery.to_sql}) sub ON user_paginisites.user_id = sub.user_id AND user_paginisites.created_at = sub.max_created_at")
                       .includes(:user, :paginisite)
                       .where(paginisites: { nume: 'Login' })
                       .ransack(
                         user_email_cont: search_term, 
                         user_name_cont: search_term, 
                         m: 'or'
                       )
  
    @user_paginisite = @q.result.order('user_paginisites.created_at DESC')
  
    # Calculate the visit_counts
    @visit_counts = UserPaginisite.group(:user_id).count

  # restul codului ta
    workbook = RubyXL::Workbook.new
  
    # Select the first worksheet
    worksheet = workbook[0]
  
    # Add the headers
    worksheet.add_cell(0, 0, 'Nume')
    worksheet.add_cell(0, 1, 'Email')
    worksheet.add_cell(0, 2, 'Pagina accesata')
    worksheet.add_cell(0, 3, 'Numar accesari')
    worksheet.add_cell(0, 4, 'Ultima data si ora')
  
    # Add the data
    @user_paginisite.each_with_index do |up, index|
      worksheet.add_cell(index + 1, 0, up.user.name)
      worksheet.add_cell(index + 1, 1, up.user.email)
      worksheet.add_cell(index + 1, 2, up.paginisite.nume)
      worksheet.add_cell(index + 1, 3, @visit_counts[up.user_id] || 0)
      worksheet.add_cell(index + 1, 4, up.created_at.in_time_zone('Eastern Time (US & Canada)').advance(hours: 7).strftime('%d-%m-%Y %H:%M:%S'))
    end
  
    file_path = Rails.root.join('tmp', 'user_paginisite.xlsx')
    workbook.write(file_path)
    send_file(file_path)

  end
  
  # export in xlsx lista utilizatori care NU s-au logat nici macar odata
  def export_to_xlsx_no_login
    search_term = params[:search]
  
    # Get all user ids that have logged in
    logged_in_user_ids = UserPaginisite.joins(:paginisite)
                                       .where(paginisites: { nume: 'Login' })
                                       .distinct
                                       .pluck(:user_id)

                                       
  
    # Get the users that have not logged in
    @q = User.where.not(id: logged_in_user_ids)
             .ransack(
               email_cont: search_term, 
               name_cont: search_term, 
               m: 'or'
             )
  
    @users = @q.result.distinct.order('created_at DESC')
  
    workbook = RubyXL::Workbook.new
    worksheet = workbook[0]
    
    # Add the headers
    worksheet.add_cell(0, 0, 'Nume')
    worksheet.add_cell(0, 1, 'Email')
    worksheet.add_cell(0, 2, 'Pagina neaccesata')
  
    # Add the data
    @users.each_with_index do |user, index|
      worksheet.add_cell(index + 1, 0, user.name)
      worksheet.add_cell(index + 1, 1, user.email)
      worksheet.add_cell(index + 1, 2, 'Login')
    end
    
    file_path = Rails.root.join('tmp', 'users_no_login.xlsx')
    workbook.write(file_path)
    send_file(file_path)
  end
   

  def export_to_xlsx_plata_nutritie3
    begin
      prod_ids = Prod.where(curslegatura: "Nutritie3").pluck(:id)
      mapare_valori = Prod.where(curslegatura: "Nutritie3").pluck(:id, :pret).to_h
      
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
  



  def export_to_xlsx_plata_an1 
    begin
      produse = Prod.where(curslegatura: ["Curs Ayurveda an 1", "an1"])
      mapare_valori = produse.each_with_object({}) { |prod, hash| hash[prod.id] = prod.pret }
      
      if params[:order_by] == 'email_unique'
        unique_emails = User.joins(:comenzi_prods)
                            .where(comenzi_prods: { prod_id: mapare_valori.keys, validat: "Finalizata" })
                            .group('users.email')
                            .having('count(users.email) = 1')
                            .pluck('users.email')
      
        @comenzi_prod = ComenziProd.includes(:user, :prod, comanda: :adresa_comenzi)
                                   .where(prod_id: mapare_valori.keys, validat: "Finalizata")
                                   .where(users: { email: unique_emails })
                                   .order("users.email", :comanda_id)
      elsif params[:order_by] == 'email'
        @comenzi_prod = ComenziProd.includes(:user, :prod, comanda: :adresa_comenzi)
                                   .where(prod_id: mapare_valori.keys, validat: "Finalizata")
                                   .order("users.email", :comanda_id)
     

      else
        @comenzi_prod = ComenziProd.includes(:user, :prod, comanda: :adresa_comenzi)
                                   .where(prod_id: mapare_valori.keys, validat: "Finalizata")
                                   .order("created_at ASC")
      end
                       
      
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
  
        valoare = mapare_valori[comanda.prod_id] || 0
        
        if comanda.user.email=="nagy.edvin@yahoo.com" && comanda.prod.cod!="cod14" #custom
          worksheet.add_cell(index + 1, 6, 35)
        else  
          worksheet.add_cell(index + 1, 6, valoare)        
        end  
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


 



  def export_to_xlsx_summary # comanda_id
    begin
      # Define lunile if it's not already set somewhere else
      lunile = ['Octombrie 2023', 'Noiembrie 2023', 'Decembrie 2023', 'Ianuarie 2024', 'Februarie 2024', 'Martie 2024', 'Aprilie 2024', 'Mai 2024', 'Iunie 2024', 'Iulie 2024']
      coduri = (14..25).to_a.map { |num| "cod#{num}" }
      produse = Prod.where(cod: coduri)
      mapare_coduri_id = produse.map { |prod| [prod.cod, prod.id] }.to_h
      
      user_ids = ComenziProd.where(prod_id: mapare_coduri_id.values, validat: "Finalizata").distinct.pluck(:user_id)
      users = User.where(id: user_ids)
      
      # Inițializăm un hash pentru a ține evidența plăților utilizatorilor
      user_payments = {}
      
      users.each do |user|
        user_plati = ComenziProd.where(user_id: user.id, prod_id: mapare_coduri_id.values, validat: "Finalizata")
      
        # Inițializăm datele pentru utilizator
        user_payments[user.email] ||= { 'Inscriere' => 0, 'An cu reducere' => 0 }
      
        user_plati.each do |plata|
          cod_produs = mapare_coduri_id.key(plata.prod_id)
          
          # Verificăm dacă codul produsului a fost deja procesat pentru acest utilizator
          next if user_payments[user.email].key?(cod_produs)
      
          case cod_produs
          when 'cod14'
            user_payments[user.email]['Inscriere'] += 60
          when 'cod15'
            user_payments[user.email]['An cu reducere'] += 1620
            lunile[0..5].each { |luna| user_payments[user.email][luna] = 180 } # Iunie 2023 inclusiv
            user_payments[user.email]['Iulie 2023'] = 'Gratuit'
          else # Pentru coduri de la cod16 la cod25
            # Calculăm indexul lunii pe baza codului produsului
            index_luna = cod_produs.slice(3..).to_i - 16 + 9 # +9 pentru a începe de la Octombrie 2023
            luna_corespondenta = lunile[index_luna]
            user_payments[user.email][luna_corespondenta] = 180 if luna_corespondenta # Adăugăm plata dacă luna există
          end
      
          # Marcăm codul produsului ca fiind procesat pentru acest utilizator
          user_payments[user.email][cod_produs] = true
        end
      end
      
      # La final, user_payments va conține toate plățile utilizatorilor
      
        
        
      monthly_payments_summary = Hash.new(0)
      user_payments.each do |email, payments|
        payments.each do |payment, amount|
          next unless lunile.include?(payment)
          monthly_payments_summary[payment] += amount
        end
      end
     
      headers = ['e-mail USER', 'Nume USER', 'Telefon USER', 'email din FACTURA', 'Nume din FACTURA',
      'Telefon din FACTURA', 'inscriere', 'an cu reducere', 'octombrie 2023', 'noiembrie 2023',
      'decembrie 2023', 'ianuarie 2024', 'februarie 2024', 'martie 2024', 'aprilie 2024',
      'mai 2024', 'iunie 2024', 'iulie 2024']

     workbook = RubyXL::Workbook.new
     worksheet = workbook[0]
     headers.each_with_index do |header, col_index|
      worksheet.add_cell(0, col_index, header)
    end



    user_payments.each_with_index do |(email, payments), row|
      user = User.find_by(email: email)
      factura = Factura.find_by(user_id: user.id)
      
      if factura.nil?
        
            nume = "-"
            prenume = "-"
            telefon = user.telefon
            email = "-"
        
                puts "factura este nil"
                # Gestionați cazul când factura este nil
      else
       
        if factura.comanda_id.present?
         
          adresa_comenzi = AdresaComenzi.find_by(comanda_id: factura.comanda_id)
          
          if adresa_comenzi.nil?
            
            detalii_factura = Detaliifacturare.find_by(user_id: factura.user_id)
            if detalii_factura
             
              nume = detalii_factura.nume
              prenume = detalii_factura.prenume
              telefon = detalii_factura.telefon
              email = factura.user.email
            end
          else
           
            nume = adresa_comenzi.nume
            prenume = adresa_comenzi.prenume
            telefon = adresa_comenzi.telefon
            email = adresa_comenzi.email
          end
      
        end
     
      end
      worksheet.add_cell(row + 1, 0, user.email)
      worksheet.add_cell(row + 1, 1, user.name)
      worksheet.add_cell(row + 1, 2, telefon || "N/A")
      worksheet.add_cell(row + 1, 3, email || "N/A")
      worksheet.add_cell(row + 1, 4, "#{prenume} #{nume}" || "N/A")
      worksheet.add_cell(row + 1, 5, telefon || "N/A")
      
      # Populate product values
      comenzi_for_user = ComenziProd.where(user_id: user.id, prod_id: mapare_coduri_id.values, validat: "Finalizata")
      
      # initialize all payments to 0
      values = Array.new(12, 0)

      has_cod15 = comenzi_for_user.where(prod_id: mapare_coduri_id['cod15']).exists?

      comenzi_for_user.each do |comanda|
        cod = Prod.find(comanda.prod_id).cod
        pret = Prod.find(comanda.prod_id).pret
        if user.email=="nagy.edvin@yahoo.com" && cod!="cod14" #custom
          pret=35
        end  
      
        case cod
        when 'cod14'
          values[0] = pret
        when 'cod15'
          values[1] = pret
          values.fill(180, 2..10) if has_cod15 # 2 to 10 for cod16 to cod24
          values[11] = "gratuit" if has_cod15 # 11 for cod25
        else
          # Dacă utilizatorul nu are cod15, vom decrementa indexul cu 1 pentru cod16 și codurile ulterioare
          index_shift = has_cod15 ? 0 : 1
          index = cod.slice(3..).to_i - 14 + 1 - index_shift
          values[index] = pret if index < 12 && values[index] == 0
        end
      end
      
      values.each_with_index do |value, index|
        worksheet.add_cell(row + 1, 6 + index, value == 0 ? nil : value)
      end
      

    end
 
    file_path = Rails.root.join('tmp', "comenzi_prod_#{Time.now.to_i}.xlsx")
    workbook.write(file_path)
    send_file(file_path)

  ensure
    # Cleanup the temporary file
    # File.delete(file_path) if File.exist?(file_path)
  end
rescue => e
  # Handle any exception and possibly notify the user or log the error
  logger.error "Error generating Excel: #{e.message}"
  redirect_to root_path, alert: "There was an error generating the report. Please try again later."
end
  





  def export_to_xlsx_plata_tayv2
    begin
      prod_ids = Prod.where(curslegatura: "tayv2").pluck(:id)
      mapare_valori = prod_ids.each_with_object({}) { |id, hash| hash[id] = Prod.find(id).pret }

      @comenzi_prod = ComenziProd.includes(:user, :prod, comanda: :adresa_comenzi)
                                 .where(prod_id: mapare_valori.keys, validat: "Finalizata")
                                 .order("users.email", :comanda_id)
  
      user_ids = @comenzi_prod.map(&:user_id).uniq
      detaliifacturare_hash = Detaliifacturare.where(user_id: user_ids).index_by(&:user_id)
      
  
      workbook = RubyXL::Workbook.new
      worksheet = workbook[0]
  
      #headers = ['Email', 'Nume User', 'Telefon', 'Nume din Factura', 'Telefon din factura', 'Data Platii', 'Valoare', 'Comanda ID', 'Adresă de livrare', 'Plată prin', 'Nume Produs', 'Validat']
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
  
        valoare = mapare_valori[comanda.prod_id] || 0
        worksheet.add_cell(index + 1, 6, valoare)
  
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
   
         worksheet.add_cell(index + 1, 11, comanda.comanda.plataprin) if comanda.comanda
   
         worksheet.add_cell(index + 1, 12, comanda.prod.nume)
         
         worksheet.add_cell(index + 1, 13, comanda.validat)
       end
   
       file_path = Rails.root.join('tmp', "comenzi_prod_#{Time.now.to_i}.xlsx")
       workbook.write(file_path)
       send_file(file_path)
     ensure
       # Cleanup the temporary file
       # File.delete(file_path) if File.exist?(file_path)
     end
   rescue => e
     logger.error "Error generating Excel: #{e.message}"
     redirect_to root_path, alert: "There was an error generating the report. Please try again later."
   end
  



  def export_to_xlsx_plata_tayt12
    begin
      produse = Prod.where(curslegatura: "tayt12")
      mapare_valori = produse.each_with_object({}) { |prod, hash| hash[prod.id] = prod.pret }
    
      @comenzi_prod = ComenziProd.includes(:user, :prod, comanda: :adresa_comenzi)
                                 .where(prod_id: mapare_valori.keys, validat: "Finalizata")
                                 .order(:comanda_id)
    
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
  
        valoare = mapare_valori[comanda.prod_id] || 0
        worksheet.add_cell(index + 1, 6, valoare)
  
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
  
        worksheet.add_cell(index + 1, 11, comanda.comanda.plataprin) if comanda.comanda
  
        worksheet.add_cell(index + 1, 12, comanda.prod.nume)
        
        worksheet.add_cell(index + 1, 13, comanda.validat)
      end
  
      file_path = Rails.root.join('tmp', "comenzi_prod_#{Time.now.to_i}.xlsx")
      workbook.write(file_path)
      send_file(file_path)
    ensure
      # Cleanup the temporary file
      # File.delete(file_path) if File.exist?(file_path)
    end
  rescue => e
    logger.error "Error generating Excel: #{e.message}"
    redirect_to root_path, alert: "There was an error generating the report. Please try again later."
  end
  
  def export_to_xlsx_plata_vajikarana_modul1
    begin
      prod_ids = Prod.where(curslegatura: "vajikarana1").pluck(:id)
      mapare_valori = Prod.where(curslegatura: "vajikarana1").pluck(:id, :pret).to_h
      
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



  def export_to_xlsx_plata_amnaya
    begin
      cursuri = ['jamadagni', 'asita', 'performanta_cognitiva', 'cognitronica', 'jivaka', 'traditia_ayurvedica','hiranyaksha','sharaloma','saunaka','maudgalya']
      prod_ids = Prod.where(curslegatura: cursuri).pluck(:id)
      mapare_valori = Prod.where(curslegatura: cursuri).pluck(:id, :pret).to_h
      
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

  def export_to_xlsx_plata_generala_curs
    begin
      prod_ids = Prod.where(curslegatura: "platageneralacurs").pluck(:id)
      mapare_valori = prod_ids.each_with_object({}) { |id, hash| hash[id] = Prod.find(id).pret }

      @comenzi_prod = ComenziProd.includes(:user, :prod, comanda: :adresa_comenzi)
                                 .where(prod_id: mapare_valori.keys, validat: "Finalizata")
                                 .order("users.email", :comanda_id)
  
      user_ids = @comenzi_prod.map(&:user_id).uniq
      detaliifacturare_hash = Detaliifacturare.where(user_id: user_ids).index_by(&:user_id)
      
  
      workbook = RubyXL::Workbook.new
      worksheet = workbook[0]
  
      #headers = ['Email', 'Nume User', 'Telefon', 'Nume din Factura', 'Telefon din factura', 'Data Platii', 'Valoare', 'Comanda ID', 'Adresă de livrare', 'Plată prin', 'Nume Produs', 'Validat']
     

      headers = ['Email', 'Nume User', 'Telefon', 'Nume din factură', 'Telefon din factură', 'Data Platii', 'Valoare', 'Cantitate', 'Total', 'Comandă ID', 'Nume livrare', 'Telefon livrare', 'Adresă de livrare', 'Plată prin', 'Nume Produs', 'Validat', 'Observații']


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
  
        valoare = mapare_valori[comanda.prod_id] || 0
        worksheet.add_cell(index + 1, 6, valoare)
        cantitate = comanda.cantitate || "N/A" # Assuming 'cantitate' field exists
        worksheet.add_cell(index + 1, 7, cantitate)
        total = comanda.pret_total || "N/A" # Assuming 'pret_total' field exists
        worksheet.add_cell(index + 1, 8, total)
  
        worksheet.add_cell(index + 1, 9, comanda.comanda_id)
  
         # Nume din Livrare
         adresa = comanda.comanda&.adresa_comenzi
         detaliifacturare = detaliifacturare_hash[comanda.user.id]
         nume_livrare = if adresa
                           "#{adresa.nume} #{adresa.prenume}"
                         elsif detaliifacturare
                           "#{detaliifacturare.nume} #{detaliifacturare.prenume}"
                         end
         worksheet.add_cell(index + 1, 10, nume_livrare)
       
         # Telefon din livrare
         telefon_livrare = adresa&.telefon || detaliifacturare&.telefon
         worksheet.add_cell(index + 1, 11, telefon_livrare)
         
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
         worksheet.add_cell(index + 1, 12, adresa_livrare)
   
         worksheet.add_cell(index + 1, 13, comanda.comanda.plataprin) if comanda.comanda
   
         worksheet.add_cell(index + 1, 14, comanda.prod.nume)
         
         worksheet.add_cell(index + 1, 15, comanda.validat)
         obs = comanda.obs || "N/A"  # Fallback to "N/A" if obs is NULL
         worksheet.add_cell(index + 1, 16, obs)
       end
   
       file_path = Rails.root.join('tmp', "comenzi_prod_#{Time.now.to_i}.xlsx")
       workbook.write(file_path)
       send_file(file_path)
     ensure
       # Cleanup the temporary file
       # File.delete(file_path) if File.exist?(file_path)
     end
   rescue => e
     logger.error "Error generating Excel: #{e.message}"
     redirect_to root_path, alert: "There was an error generating the report. Please try again later."
   end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_paginisite
      @paginisite = Paginisite.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def paginisite_params
      params.require(:paginisite).permit(:nume)
    end
    def set_user
      # Verifica daca userul este logat
      if current_user
        # Verifica daca userul este admin sau asociat cu cursul "Nutritie"
        if current_user.role == 1 
          # Utilizatorul are acces la resursa
        else
          # Utilizatorul nu are acces la resursa
          flash[:alert] = "Nu ai acces la această resursă."
          redirect_to root_path
        end
      else
        # Utilizatorul nu este logat
        flash[:alert] = "Trebuie să te autentifici pentru a accesa această resursă."
        redirect_to login_path
      end
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



    
    
  end
