class Admin::UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[index edit update]
  before_action :require_admin, only: %i[index edit update]
  before_action :set_user, only: [:edit, :update]

  def index
    @users = User.all
    #@user = User.last
    #render turbo_frame: "hello"
  end
    
  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "User updated successfully."
    else
      render :edit
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
