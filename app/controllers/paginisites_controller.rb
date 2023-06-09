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
