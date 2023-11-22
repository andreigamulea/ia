class CustomRegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create]
    
    def create
        # Extrage și salvează return_to în sesiune înainte de a apela super
        if params[:user][:return_to].present?
          session[:user_return_to] = params[:user][:return_to]
          params[:user].delete(:return_to) # Elimină return_to din parametrii user
        end
      
        super # Acum cheamă metoda originală create din Devise
      end
      

    protected

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation])
    end
  
   
  end
  