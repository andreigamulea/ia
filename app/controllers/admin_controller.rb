class AdminController < ApplicationController
  before_action :authenticate_user!, only: %i[index edit update]
  before_action :require_admin, only: %i[index new edit update create]
  before_action :set_user, only: [:edit, :update]
  
  def index
    @q = User.ransack(params[:q])
    # Sorts the result by `id` in ascending order
    @users = @q.result.order(id: :asc).page(params[:page]).per(15)
  end


  def export_users_to_xlsx
    users = User.all.order(:id)  # Fetches all users and orders them by ID
  
    # Create a new workbook
    workbook = RubyXL::Workbook.new
  
    # Use the first worksheet
    worksheet = workbook[0]
    worksheet.sheet_name = 'Users'
  
    # Define the headers
    headers = ['ID', 'Email', 'Name', 'Telefon']
    headers.each_with_index do |header, index|
      worksheet.add_cell(0, index, header)  # Adds headers to the first row
    end
  
    # Populate the worksheet with user data
    users.each_with_index do |user, index|
      worksheet.add_cell(index + 1, 0, user.id)
      worksheet.add_cell(index + 1, 1, user.email)
      worksheet.add_cell(index + 1, 2, user.name)
      worksheet.add_cell(index + 1, 3, user.telefon)
    end
  
    # Save the workbook to a file
    file_path = Rails.root.join('tmp', 'users.xlsx')
    workbook.write(file_path)
  
    # Optionally, send the file to the user
    send_file(file_path, filename: 'users.xlsx', type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
  end
  




  
  def new #se creaza un utilizator nou
    @user = User.new
  end
  
  def create #se inregistreaza in tabela utilizatorul nou
    @user = User.new(user_params.except(:cursuri))
    
    if @user.save
      listacursuris = Listacursuri.all
  
      listacursuris.each do |lc|
        if params[:user][:cursuri][lc.id.to_s].present? && params[:user][:cursuri][lc.id.to_s][:selected] == '1'
          curs = @user.cursuri.new(
            listacursuri: lc,
            datainceput: params[:user][:cursuri][lc.id.to_s][:datainceput],
            datasfarsit: params[:user][:cursuri][lc.id.to_s][:datasfarsit]
          )
          curs.save
          
          # Creează o înregistrare nouă în CursuriHistory
          cursuri_history = CursuriHistory.new(
            user_id: @user.id,
            listacursuri_id: lc.id,
            cursuri_id: curs.id,
            datainceput: curs.datainceput,
            datasfarsit: curs.datasfarsit,
            modificatde: current_user.name
          )
  
          if cursuri_history.valid?
            cursuri_history.save
          else
            puts "CursuriHistory is not valid. Errors: #{cursuri_history.errors.full_messages}"
          end
        end
      end
  
      redirect_to admin_index_path, notice: "User was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end
  
    
  def edit
  end

  def update
    respond_to do |format|
      begin
        # Verificăm și transformăm stringurile în hash-uri Ruby folosind JSON.parse
        if params[:user][:gr].present? && params[:user][:gr].is_a?(String)
          Rails.logger.debug "DEBUG - Parsing GR"
          params[:user][:gr] = JSON.parse(params[:user][:gr]) rescue params[:user][:gr]
          Rails.logger.debug "DEBUG - Parsed GR: #{params[:user][:gr]}"
        end
  
        if params[:user][:taxa].present? && params[:user][:taxa].is_a?(String)
          Rails.logger.debug "DEBUG - Parsing Taxa"
          params[:user][:taxa] = JSON.parse(params[:user][:taxa]) rescue params[:user][:taxa]
          Rails.logger.debug "DEBUG - Parsed Taxa: #{params[:user][:taxa]}"
        end
  
        # Debug pentru parametrii permiși
        Rails.logger.debug "DEBUG - Permitted user params: #{user_params.inspect}"
  
        # Actualizarea utilizatorului cu noile valori pentru gr și taxa
        if @user.update(user_params.except(:cursuri))
          Rails.logger.debug "DEBUG - User updated successfully"
  
          # Logica existentă pentru actualizarea cursurilor
          listacursuris = Listacursuri.all
          @user_cursuri_original = @user.cursuri.map { |curs| [curs.listacursuri_id, [curs.datainceput, curs.datasfarsit]] }.to_h
  
          Rails.logger.debug "DEBUG - Original courses: #{@user_cursuri_original}"
  
          @user.cursuri.destroy_all
          listacursuris.each do |lc|
            if params[:user][:cursuri][lc.id.to_s].present? && params[:user][:cursuri][lc.id.to_s][:selected] == '1'
              Rails.logger.debug "DEBUG - Adding course: #{lc.inspect}"
              curs = @user.cursuri.new(
                listacursuri: lc,
                datainceput: params[:user][:cursuri][lc.id.to_s][:datainceput],
                datasfarsit: params[:user][:cursuri][lc.id.to_s][:datasfarsit]
              )
              curs.save
              Rails.logger.debug "DEBUG - Course saved: #{curs.inspect}"
            end
          end
  
          @user_cursuri_nou = @user.cursuri.map { |curs| [curs.listacursuri_id, [curs.datainceput, curs.datasfarsit]] }.to_h
          Rails.logger.debug "DEBUG - New courses: #{@user_cursuri_nou}"
  
          @user_cursuri_nou.each do |listacursuri_id, (datainceput_nou, datasfarsit_nou)|
            if @user_cursuri_original[listacursuri_id].present?
              datainceput_vechi, datasfarsit_vechi = @user_cursuri_original[listacursuri_id]
            else
              datainceput_vechi, datasfarsit_vechi = nil, nil
            end
  
            Rails.logger.debug "DEBUG - Checking course #{listacursuri_id}: Old dates: #{datainceput_vechi}, #{datasfarsit_vechi}. New dates: #{datainceput_nou}, #{datasfarsit_nou}"
  
            if @user_cursuri_original[listacursuri_id] != [datainceput_nou, datasfarsit_nou] || (datainceput_vechi.present? && datainceput_nou.blank?) || (datasfarsit_vechi.present? && datasfarsit_nou.blank?)
              if params[:user][:cursuri][listacursuri_id.to_s][:selected] == '1'
                curs = @user.cursuri.find_by(listacursuri_id: listacursuri_id)
                cursuri_history = CursuriHistory.new(
                  user_id: @user.id,
                  listacursuri_id: listacursuri_id,
                  cursuri_id: curs.id,
                  datainceput: datainceput_nou,
                  datasfarsit: datasfarsit_nou,
                  modificatde: current_user.name
                )
  
                if cursuri_history.valid?
                  cursuri_history.save
                  Rails.logger.debug "DEBUG - History saved: #{cursuri_history.inspect}"
                else
                  Rails.logger.debug "DEBUG - History invalid: #{cursuri_history.errors.full_messages}"
                end
              end
            end
          end
  
          format.js
          format.html { redirect_to update_admin_path(@user), notice: "User was successfully updated." }
        else
          Rails.logger.debug "DEBUG - User update failed: #{@user.errors.full_messages}"
          format.js
          format.html { render :edit, status: :unprocessable_entity }
        end
      rescue JSON::ParserError => e
        Rails.logger.debug "DEBUG - JSON Parsing Error: #{e.message}"
        flash[:alert] = "Format invalid pentru GR sau Taxa. Asigură-te că ai introdus un JSON valid."
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end
 

  private

  def require_admin
    unless current_user && current_user.role == 1
      flash[:error] = "Only admins are allowed to access this page."
      redirect_to root_path
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :name, :email, :password, :password_confirmation, :limba, :role, :active, 
      :gdpr, :telefon, :telefon2, :telefon3, :grupa, :nutritieabsolvit, 
      :reset_password_token, :reset_password_sent_at, :remember_created_at, 
      :stripe_customer_id, :current_sign_in_token, :google_token, :provider, 
      :uid, :google_refresh_token, :last_sign_in_at, :current_sign_in_at, 
      :last_sign_in_ip, :current_sign_in_ip, :sign_in_count, :cpa, :cnp, gr: {},taxa: {}, cursuri: {}
    )
  end
  
 
  
  
end
