class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
    #before_action :authenticate_user!
    before_action :check_user_active


       
    protected
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:email,:name, :role])
        devise_parameter_sanitizer.permit(:account_update, keys: [:email,:name, :role])
    end
    private
    def require_admin
        unless current_user && current_user.role == 1
          flash[:error] = "Only admins are allowed to access this page."
          redirect_to root_path
        end
      end
      def check_user_active
        if current_user && current_user.active == false
          sign_out(current_user)
          flash[:alert] = "Your account has been deactivated. Please contact support if you have any questions."
          redirect_to root_path
        end
      end
end
