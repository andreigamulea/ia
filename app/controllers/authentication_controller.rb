class AuthenticationController < Devise::SessionsController
  skip_before_action :check_sign_in_token, only: :create

  def create
    self.resource = warden.authenticate!(auth_options)
    if resource.nil?
      Rails.logger.info("Authentication failed for email #{params[:user][:email]}")
      redirect_to new_user_session_path, alert: "Autentificare esuata."
      return
    end
  
    if resource.active?
      set_flash_message(:notice, :signed_in) if is_flashing_format?
      sign_in(resource_name, resource)
      new_token = SecureRandom.hex
      resource.update!(current_sign_in_token: new_token)  # genereaza un nou token la fiecare autentificare
      session[:user_token] = new_token  # actualizeaza tokenul in sesiune
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      Rails.logger.info("User #{resource.email} is inactive.")
      sign_out(resource_name)
      redirect_to new_user_session_path, alert: "Contul dvs. este dezactivat. Vă rugăm să contactați administratorul."
    end
  end
  
end
