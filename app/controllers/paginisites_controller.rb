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
    
    # Perform the search using Ransack with a condition on user's email or name
    @q = UserPaginisite.includes(:user, :paginisite).where(paginisites: { nume: 'Login' }).ransack(
      user_email_or_user_name_cont: search_term, 
      m: 'or'
    )
  
    # Get the result, order it by creation date and paginate it
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



  def export_to_xlsx_plata_vajikarana_modul2
    begin
      prod_ids = Prod.where(curslegatura: "vajikarana2").pluck(:id)
      mapare_valori = Prod.where(curslegatura: "vajikarana2").pluck(:id, :pret).to_h
      
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

  def export_to_xlsx_plata_psihofonoterapie
    begin
      prod_ids = Prod.where(curslegatura: "psihofonoterapie").pluck(:id)
      mapare_valori = Prod.where(curslegatura: "psihofonoterapie").pluck(:id, :pret).to_h
      
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
    ## Handle any exception and possibly notify the user or log the error
    logger.error "Error generating Excel: #{e.message}"
    redirect_to root_path, alert: "There was an error generating the report. Please try again later."
  end

  



   def export_to_xlsx_plata_sesiunevara
    begin
      prod_ids = Prod.where(curslegatura: "sesiune_vara").pluck(:id)
      mapare_valori = Prod.where(curslegatura: "sesiune_vara").pluck(:id, :pret).to_h
      
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




##an1 2024-2025
def export_to_xlsx_summary_2024_2025
  puts "da1 - începe metoda"
  begin
    puts "da2 - înainte de setarea lunilor și codurilor"
    
    lunile = ['Octombrie 2024', 'Noiembrie 2024', 'Decembrie 2024', 'Ianuarie 2025', 'Februarie 2025', 'Martie 2025', 'Aprilie 2025', 'Mai 2025', 'Iunie 2025', 'Iulie 2025']
    coduri = (195..206).to_a.map { |num| "cod#{num}" }
    produse = Prod.where(cod: coduri)
    mapare_coduri_id = produse.map { |prod| [prod.cod, prod.id] }.to_h

    puts "Produse găsite: #{produse.inspect}"
    puts "Mapare coduri - ID: #{mapare_coduri_id.inspect}"

    user_ids = ComenziProd.where(prod_id: mapare_coduri_id.values, validat: "Finalizata").distinct.pluck(:user_id)

  # Obține user_ids care au plătit `cod195`
  user_ids_cu_cod195 = ComenziProd.where(prod_id: mapare_coduri_id['cod195'], validat: "Finalizata").distinct.pluck(:user_id)

  # Filtrează doar utilizatorii care au plătit și `cod195`
  user_ids_final = user_ids & user_ids_cu_cod195

  # Încărcăm utilizatorii finali care au plătit și `cod195`
  users = User.where(id: user_ids_final)
  puts "Aceștia sunt userii care au plătit cod195: #{users.inspect}"
    puts("Acestia sunt userii: #{users}")
    puts "User IDs: #{user_ids.inspect}"
    puts "Users găsiți: #{users.inspect}"

    user_payments = {}

    users.each do |user|
      puts "Procesăm utilizatorul: #{user.email}"

      # Obține comenzile pentru utilizator
      comenzi_for_user = ComenziProd.where(user_id: user.id, prod_id: mapare_coduri_id.values, validat: "Finalizata")
      puts "Comenzi produse pentru utilizator: #{comenzi_for_user.inspect}"

      if comenzi_for_user.empty?
        puts "ATENȚIE: `comenzi_for_user` este gol pentru utilizatorul #{user.email}!"
        next
      end

      comenzi_for_user.each do |comanda|
        cod = Prod.find(comanda.prod_id).cod
        pret = Prod.find(comanda.prod_id).pret

        puts "Produs procesat: cod=#{cod}, pret=#{pret}"

        # Logica personalizată pentru preț
        if user.email == "nagy.edvin@yahoo.com" && cod != "cod195"
          pret = 35
          puts "Preț personalizat pentru #{user.email}: #{pret}"
        end

        user_payments[user.email] ||= { 'Inscriere' => 0, 'An cu reducere' => 0 }
        puts "Structura inițializată pentru #{user.email}: #{user_payments[user.email].inspect}"

        case cod
        when 'cod195'
          user_payments[user.email]['Inscriere'] += pret
        when 'cod196'
          user_payments[user.email]['An cu reducere'] += pret
          lunile[0..8].each { |luna| user_payments[user.email][luna] = 180 }
          user_payments[user.email]['Iulie 2025'] = 'Gratuit'
        else
          if cod.slice(3..).to_i >= 197
            index_luna = cod.slice(3..).to_i - 197
            luna_corespondenta = lunile[index_luna]
            puts "Procesăm cod #{cod} pentru luna corespondentă: #{luna_corespondenta}"

            if luna_corespondenta
              user_payments[user.email][luna_corespondenta] ||= 0
              user_payments[user.email][luna_corespondenta] += pret
              puts "Plată adăugată pentru #{user.email}: #{luna_corespondenta} = #{user_payments[user.email][luna_corespondenta]}"
            else
              puts "ATENȚIE: Nu există lună corespondentă pentru codul #{cod}!"
            end
          end
        end
      end

      puts "Sfârșitul buclei `comenzi_for_user.each` pentru utilizatorul #{user.email}"
      puts "Plăți curente pentru #{user.email}: #{user_payments[user.email].inspect}"
    end

    puts "da3 - sfârșitul procesării user_payments: #{user_payments.inspect}"

    # Cod pentru generarea fișierului Excel
    begin
      headers = ['e-mail USER', 'Nume USER', 'Telefon USER', 'email din FACTURA', 'Nume din FACTURA',
                 'Telefon din FACTURA', 'inscriere', 'an cu reducere', 'octombrie 2024', 'noiembrie 2024',
                 'decembrie 2024', 'ianuarie 2025', 'februarie 2025', 'martie 2025', 'aprilie 2025',
                 'mai 2025', 'iunie 2025', 'iulie 2025']

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
          email_factura = "-"
        else
          if factura.comanda_id.present?
            adresa_comenzi = AdresaComenzi.find_by(comanda_id: factura.comanda_id)
            if adresa_comenzi.nil?
              detalii_factura = Detaliifacturare.find_by(user_id: factura.user_id)
              if detalii_factura
                nume = detalii_factura.nume
                prenume = detalii_factura.prenume
                telefon = detalii_factura.telefon
                email_factura = factura.user.email
              end
            else
              nume = adresa_comenzi.nume
              prenume = adresa_comenzi.prenume
              telefon = adresa_comenzi.telefon
              email_factura = adresa_comenzi.email
            end
          end
        end

        worksheet.add_cell(row + 1, 0, user.email)
        worksheet.add_cell(row + 1, 1, user.name)
        worksheet.add_cell(row + 1, 2, telefon || "N/A")
        worksheet.add_cell(row + 1, 3, email_factura || "N/A")
        worksheet.add_cell(row + 1, 4, "#{prenume} #{nume}" || "N/A")
        worksheet.add_cell(row + 1, 5, telefon || "N/A")

        # Populate product values
        values = Array.new(12, 0)

        payments.each do |payment, amount|
          if lunile.include?(payment)
            index = lunile.index(payment) + 2
            values[index] = amount
          else
            case payment
            when 'Inscriere'
              values[0] = amount
            when 'An cu reducere'
              values[1] = amount
            end
          end
        end

        values.each_with_index do |value, index|
          worksheet.add_cell(row + 1, 6 + index, value == 0 ? nil : value)
        end
      end

      file_path = Rails.root.join('tmp', "comenzi_prod_2024_2025_#{Time.now.to_i}.xlsx")
      workbook.write(file_path)
      send_file(file_path)
    rescue => e
      puts "Eroare la scrierea în worksheet: #{e.message}"
    end

    puts "da7 - blocul ensure"
    # Cleanup the temporary file
    # File.delete(file_path) if File.exist?(file_path)
  end
rescue => e
  puts "da8 - eroare: #{e.message}"
  logger.error "Error generating Excel: #{e.message}"
  redirect_to root_path, alert: "There was an error generating the report. Please try again later."
end

def export_to_xlsx_plata_an2_2425
  begin
    # Produsele cod25 și cod15 pentru eligibilitate
    produse_eligibile = Prod.where(cod: ['cod25', 'cod15'])
    
    # Găsim utilizatorii care au cumpărat cod25 sau cod15
    email_de_exclus = 'mileamihaela1975@gmail.com'
    user_de_exclus_id = User.where(email: email_de_exclus).pluck(:id).first
    
    utilizatori_eligibili_ids = ComenziProd.where(prod_id: produse_eligibile.ids, validat: "Finalizata")
                                           .where.not(user_id: user_de_exclus_id)
                                           .pluck(:user_id)
                                           .uniq

    # Array cu utilizatori pentru cazuri particulare (inițial gol)
    user_array_particulari = ['ce.hermkens@gmail.com', 'maria_mocica@yahoo.com']

    # Eliminăm utilizatorul de exclus și din lista particulară
    user_array_particulari.delete(email_de_exclus)

    # Produsele pentru anul universitar 2024-2025
    produse_an2 = Prod.where(cod: ['cod196', 'cod207', 'cod213'] + (197..206).map { |n| "cod#{n}" })

    mapare_valori_an2 = produse_an2.each_with_object({}) { |prod, hash| hash[prod.id] = prod.pret }

    # Selectăm comenzile pentru produsele din anul universitar 2024-2025
    @comenzi_prod = ComenziProd.includes(:user, :prod, comanda: :adresa_comenzi)
                               .where(prod_id: mapare_valori_an2.keys, validat: "Finalizata")
                               .where(user_id: utilizatori_eligibili_ids + User.where(email: user_array_particulari).pluck(:id))
                               .order(:comanda_id)

    # Eliminăm duplicatele (în caz că un utilizator e atât în array, cât și a cumpărat codurile eligibile)
    @comenzi_prod = @comenzi_prod.uniq

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

      factura = Factura.find_by(comanda_id: comanda.comanda_id)
      nume_factura = "#{factura.nume} #{factura.prenume}" if factura
      worksheet.add_cell(index + 1, 3, nume_factura)

      telefon_factura = comanda.comanda&.telefon
      worksheet.add_cell(index + 1, 4, telefon_factura)

      worksheet.add_cell(index + 1, 5, comanda.datainceput.strftime('%d-%m-%Y')) if comanda.datainceput

      valoare = mapare_valori_an2[comanda.prod_id] || 0
      worksheet.add_cell(index + 1, 6, valoare)

      worksheet.add_cell(index + 1, 7, comanda.comanda_id)

      adresa = comanda.comanda&.adresa_comenzi
      detaliifacturare = detaliifacturare_hash[comanda.user.id]
      nume_livrare = if adresa
                        "#{adresa.nume} #{adresa.prenume}"
                      elsif detaliifacturare
                        "#{detaliifacturare.nume} #{detaliifacturare.prenume}"
                      end
      worksheet.add_cell(index + 1, 8, nume_livrare)

      telefon_livrare = adresa&.telefon || detaliifacturare&.telefon
      worksheet.add_cell(index + 1, 9, telefon_livrare)

      if adresa
        parts = ["adresa de livrare este adresa de facturare: ", adresa.tara, adresa.judet, adresa.localitate, "cod postal: #{adresa.codpostal}", adresa.strada, adresa.numar, adresa.altedate, adresa.numecompanie, adresa.cui].compact.reject(&:empty?)
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

    file_path = Rails.root.join('tmp', "comenzi_prod_an2_2425_#{Time.now.to_i}.xlsx")
    workbook.write(file_path)
    send_file(file_path)
  ensure
    # Cleanup the temporary file
    #File.delete(file_path) if File.exist?(file_path)
  end
rescue => e
  logger.error "Error generating Excel: #{e.message}"
  redirect_to root_path, alert: "There was an error generating the report. Please try again later."
end



def export_to_xlsx_plata_rasayana_modul1
  begin
    prod_ids = Prod.where(curslegatura: "rasayana1").pluck(:id)
    mapare_valori = Prod.where(curslegatura: "rasayana1").pluck(:id, :pret).to_h
    
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




def export_to_xlsx_plata_an1_2024_2025
  begin
    # Selectează produsele corespunzătoare anului 2024-2025
    produse = Prod.where(curslegatura: ["cay2425"]) # Ajustare pentru anul 2024-2025

    # Mapare de valori produse (ID produs -> preț)
    mapare_valori = produse.each_with_object({}) { |prod, hash| hash[prod.id] = prod.pret }

    # Mapare personalizată pentru codurile produselor
    prod_cod_mapping = {
      "cod195" => "plata taxa inscriere",
      "cod196" => "plata anuala integrala 1620 lei",
      "cod197" => "plata luna octombrie",
      "cod198" => "plata luna noiembrie",
      "cod199" => "plata luna decembrie",
      "cod200" => "plata luna ianuarie",
      "cod201" => "plata luna februarie",
      "cod202" => "plata luna martie",
      "cod203" => "plata luna aprilie",
      "cod204" => "plata luna mai",
      "cod205" => "plata luna iunie",
      "cod206" => "plata luna iulie"
    }

    # Obținerea ID-ului pentru produsul `cod195`
    cod195_prod = Prod.find_by(cod: "cod195")
    return if cod195_prod.nil? # În caz că nu există produsul `cod195`, nu continuăm

    # Filtrare comenzile care includ `cod195`
    user_ids_with_cod195 = ComenziProd.where(prod_id: cod195_prod.id, validat: "Finalizata").pluck(:user_id).uniq

    # Filtrare comenzi doar pentru utilizatorii care au plătit `cod195`
    if params[:order_by] == 'email_unique'
      unique_emails = User.joins(:comenzi_prods)
                          .where(comenzi_prods: { prod_id: mapare_valori.keys, validat: "Finalizata", user_id: user_ids_with_cod195 })
                          .group('users.email')
                          .having('count(users.email) = 1')
                          .pluck('users.email')
  
      @comenzi_prod = ComenziProd.includes(:user, :prod, comanda: :adresa_comenzi)
                                 .where(prod_id: mapare_valori.keys, validat: "Finalizata", user_id: user_ids_with_cod195)
                                 .where(users: { email: unique_emails })
                                 .order("users.email", :comanda_id)
    elsif params[:order_by] == 'email'
      @comenzi_prod = ComenziProd.includes(:user, :prod, comanda: :adresa_comenzi)
                                 .where(prod_id: mapare_valori.keys, validat: "Finalizata", user_id: user_ids_with_cod195)
                                 .order("users.email", :comanda_id)
    else
      @comenzi_prod = ComenziProd.includes(:user, :prod, comanda: :adresa_comenzi)
                                 .where(prod_id: mapare_valori.keys, validat: "Finalizata", user_id: user_ids_with_cod195)
                                 .order("created_at ASC")
    end

    # Obținerea ID-urilor de useri și detalii facturare
    user_ids = @comenzi_prod.map(&:user_id).uniq
    detaliifacturare_hash = Detaliifacturare.where(user_id: user_ids).index_by(&:user_id)

    # Creare workbook Excel
    workbook = RubyXL::Workbook.new
    worksheet = workbook[0]

    # Definirea capului de tabel
    headers = ['Email', 'Nume User', 'Telefon', 'Nume din factură', 'Telefon din factură', 'Data Platii', 'Valoare', 'Comandă ID', 'Nume livrare', 'Telefon livrare', 'Adresă de livrare', 'Plată prin', 'Nume Produs', 'Validat']
    headers.each_with_index { |header, index| worksheet.add_cell(0, index, header) }

    # Popularea rândurilor din Excel cu datele din @comenzi_prod
    @comenzi_prod.each_with_index do |comanda, index|
      worksheet.add_cell(index + 1, 0, comanda.user.email)
      worksheet.add_cell(index + 1, 1, comanda.user.name)
      worksheet.add_cell(index + 1, 2, comanda.user.telefon)
      
      # Preluare informații factură
      factura = Factura.find_by(comanda_id: comanda.comanda_id)
      nume_factura = "#{factura.nume} #{factura.prenume}" if factura
      worksheet.add_cell(index + 1, 3, nume_factura)

      # Telefon din factură
      telefon_factura = comanda.comanda&.telefon
      worksheet.add_cell(index + 1, 4, telefon_factura)
  
      worksheet.add_cell(index + 1, 5, comanda.datainceput.strftime('%d-%m-%Y')) if comanda.datainceput

      # Valoarea plății și verificare custom pentru un anumit email
      valoare = mapare_valori[comanda.prod_id] || 0
      if comanda.user.email == "nagy.edvin@yahoo.com" && comanda.prod.cod != "cod195" # Actualizare cod pentru 2024-2025
        worksheet.add_cell(index + 1, 6, 35)
      else  
        worksheet.add_cell(index + 1, 6, valoare)
      end

      worksheet.add_cell(index + 1, 7, comanda.comanda_id)

      # Preluare informații de livrare
      adresa = comanda.comanda&.adresa_comenzi
      detaliifacturare = detaliifacturare_hash[comanda.user.id]
      nume_livrare = if adresa
                        "#{adresa.nume} #{adresa.prenume}"
                      elsif detaliifacturare
                        "#{detaliifacturare.nume} #{detaliifacturare.prenume}"
                      end
      worksheet.add_cell(index + 1, 8, nume_livrare)
    
      telefon_livrare = adresa&.telefon || detaliifacturare&.telefon
      worksheet.add_cell(index + 1, 9, telefon_livrare)

      # Generare adresă livrare completă
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
      
      # Atribuirea valorii pentru coloana `Nume Produs` conform mapării
      worksheet.add_cell(index + 1, 12, prod_cod_mapping[comanda.prod.cod] || comanda.prod.cod)
      worksheet.add_cell(index + 1, 13, comanda.validat)
    end
    
    # Salvare și trimitere fișier
    file_path = Rails.root.join('tmp', "comenzi_prod_2024_2025_#{Time.now.to_i}.xlsx")
    workbook.write(file_path)
    send_file(file_path)
  ensure
    # Cleanup the temporary file if necessary
    # File.delete(file_path) if File.exist?(file_path)
  end
rescue => e
  logger.error "Error generating Excel: #{e.message}"
  redirect_to root_path, alert: "There was an error generating the report. Please try again later."
end



def export_to_xlsx_plata_generala_curs1
  begin
    # Selectează comenzile care conțin produsele corespunzătoare codurilor specificate
    produse_ids = Prod.where(cod: ["cod245", "cod246", "cod126"]).pluck(:id)

    # Selectare toate comenzile pentru codurile specificate
    @comenzi_prod = ComenziProd.includes(:user, :prod, comanda: :adresa_comenzi)
                               .where(prod_id: produse_ids, validat: "Finalizata")
                               .order("users.email", :comanda_id)

    # Obținerea ID-urilor de useri și detalii facturare
    user_ids = @comenzi_prod.map(&:user_id).uniq
    detaliifacturare_hash = Detaliifacturare.where(user_id: user_ids).index_by(&:user_id)

    # Creare workbook Excel
    workbook = RubyXL::Workbook.new
    worksheet = workbook[0]

    # Definirea capului de tabel
    headers = ['Email', 'Nume User', 'Telefon', 'Nume din factură', 'Telefon din factură', 'Data Platii', 'Valoare', 'Observații', 'Comandă ID', 'Nume livrare', 'Telefon livrare', 'Adresă de livrare', 'Plată prin', 'Nume Produs', 'Validat']
    headers.each_with_index { |header, index| worksheet.add_cell(0, index, header) }

    # Popularea rândurilor din Excel cu datele din @comenzi_prod
    @comenzi_prod.each_with_index do |comanda, index|
      worksheet.add_cell(index + 1, 0, comanda.user.email)
      worksheet.add_cell(index + 1, 1, comanda.user.name)
      worksheet.add_cell(index + 1, 2, comanda.user.telefon)
      
      # Preluare informații factură
      factura = Factura.find_by(comanda_id: comanda.comanda_id)
      nume_factura = "#{factura.nume} #{factura.prenume}" if factura
      worksheet.add_cell(index + 1, 3, nume_factura)

      # Telefon din factură
      telefon_factura = comanda.comanda&.telefon
      worksheet.add_cell(index + 1, 4, telefon_factura)
  
      worksheet.add_cell(index + 1, 5, comanda.datainceput.strftime('%d-%m-%Y')) if comanda.datainceput

      # Valoarea plății (din campul `pret_total`)
      valoare = comanda.pret_total || 0
      worksheet.add_cell(index + 1, 6, valoare)

      # Observații (din campul `obs`)
      worksheet.add_cell(index + 1, 7, comanda.obs)

      worksheet.add_cell(index + 1, 8, comanda.comanda_id)

      # Preluare informații de livrare
      adresa = comanda.comanda&.adresa_comenzi
      detaliifacturare = detaliifacturare_hash[comanda.user.id]
      nume_livrare = if adresa
                        "#{adresa.nume} #{adresa.prenume}"
                      elsif detaliifacturare
                        "#{detaliifacturare.nume} #{detaliifacturare.prenume}"
                      end
      worksheet.add_cell(index + 1, 9, nume_livrare)
    
      telefon_livrare = adresa&.telefon || detaliifacturare&.telefon
      worksheet.add_cell(index + 1, 10, telefon_livrare)

      # Generare adresă livrare completă
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

      worksheet.add_cell(index + 1, 11, adresa_livrare)
      worksheet.add_cell(index + 1, 12, comanda.comanda.plataprin)
      
      # Atribuirea valorii pentru coloana `Nume Produs`
      worksheet.add_cell(index + 1, 13, comanda.prod.cod)
      worksheet.add_cell(index + 1, 14, comanda.validat)
    end
    
    # Salvare și trimitere fișier
    file_path = Rails.root.join('tmp', "comenzi_prod_#{Time.now.strftime('%Y%m%d%H%M%S')}.xlsx")
    workbook.write(file_path)
    send_file(file_path)
  ensure
    # Cleanup the temporary file if necessary
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
