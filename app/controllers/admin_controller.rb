class AdminController < ApplicationController
  before_action :authenticate_user!, only: %i[index edit update]
  before_action :require_admin, only: %i[index new edit update create]
  before_action :set_user, only: [:edit, :update]
  
  def index
    @q = User.ransack(params[:q])
    @users = @q.result.page(params[:page]).per(15)

    
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
      if @user.update(user_params.except(:cursuri))
        listacursuris = Listacursuri.all
  
        @user_cursuri_original = @user.cursuri.map { |curs| [curs.listacursuri_id, [curs.datainceput, curs.datasfarsit]] }.to_h
  
  
        @user.cursuri.destroy_all
        listacursuris.each do |lc|
          if params[:user][:cursuri][lc.id.to_s].present? && params[:user][:cursuri][lc.id.to_s][:selected] == '1'
            curs = @user.cursuri.new(
              listacursuri: lc,
              datainceput: params[:user][:cursuri][lc.id.to_s][:datainceput],
              datasfarsit: params[:user][:cursuri][lc.id.to_s][:datasfarsit]
            )
            curs.save
          end
        end
  
        @user_cursuri_nou = @user.cursuri.map { |curs| [curs.listacursuri_id, [curs.datainceput, curs.datasfarsit]] }.to_h
  
        @user_cursuri_nou.each do |listacursuri_id, (datainceput_nou, datasfarsit_nou)|
          if @user_cursuri_original[listacursuri_id].present?
            datainceput_vechi, datasfarsit_vechi = @user_cursuri_original[listacursuri_id]
          else
            datainceput_vechi, datasfarsit_vechi = nil, nil
          end
        
          puts "Checking Listacursuri ID: #{listacursuri_id}"
          puts "Original datainceput: #{datainceput_vechi}, Original datasfarsit: #{datasfarsit_vechi}"
          puts "New datainceput: #{datainceput_nou}, New datasfarsit: #{datasfarsit_nou}"
        
          if @user_cursuri_original[listacursuri_id] != [datainceput_nou, datasfarsit_nou] || (datainceput_vechi.present? && datainceput_nou.blank?) || (datasfarsit_vechi.present? && datasfarsit_nou.blank?)
            if params[:user][:cursuri][listacursuri_id.to_s][:selected] == '1'
              puts "Difference found. Creating a new entry in CursuriHistory."
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
              else
                puts "CursuriHistory is not valid. Errors: #{cursuri_history.errors.full_messages}"
              end
            end
          end
        end
  
        format.js
        #format.html { redirect_to edit_admin_user_path(@user), notice: "User was successfully updated." }
        format.html { redirect_to update_admin_path(@user), notice: "User was successfully updated." }


      else
        format.js
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
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role, :active, :gdpr, cursuri: {})
  end
  
 
  
  
end
