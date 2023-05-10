class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: [:set_inactive]
    before_action :create_cursuri_history, only: :set_inactive
  
    def set_inactive
        if current_user == @user
          # Setează utilizatorul ca fiind inactiv
          @user.update(active: false)
          sign_out(current_user)
          redirect_to root_path, notice: "Your account has been deactivated."
        else
          redirect_to root_path, alert: "You are not authorized to deactivate this account."
        end
      end
      
      
      
  
    private
    def create_cursuri_history()
        user_unhappy = UserUnhappy.new(
          user_id: @user.id,
          name: @user.name,
          email: @user.email,
          role: @user.role
        )
      
        if user_unhappy.save
          Rails.logger.info("UserUnhappy created successfully")
        else
          Rails.logger.error("UserUnhappy is not valid. Errors: #{user_unhappy.errors.full_messages}")
        end
      end
      
  
    def set_user
      @user = User.find(params[:id])
    end
  
    
  end
  