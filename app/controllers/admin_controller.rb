class AdminController < ApplicationController
  before_action :authenticate_user!, only: %i[index edit update]
  before_action :require_admin, only: %i[index edit update]
  before_action :set_user, only: [:edit, :update]

  def index
    @users = User.all
  end
    
  def edit
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        listacursuris = Listacursuri.all
  
        # Debugging: afișează informațiile cursurilor găsite
        puts "Found courses: #{listacursuris.to_a}"
  
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
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@user, partial: "users/user", locals: { user: @user }) }
        format.html { redirect_to admin_edit_path(@user), notice: "User was successfully updated." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@user, partial: "users/user", locals: { user: @user }) }
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
    params.require(:user).permit(:name, :email, :role)
  end
end
