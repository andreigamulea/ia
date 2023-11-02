class PaginisitesController < ApplicationController
  before_action :set_paginisite, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: %i[index userilogati useriunici_logati export_to_xlsx] #verifica daca utilizatorul este autentificat
  before_action :set_user, only: %i[index userilogati useriunici_logati export_to_xlsx]
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
  end
