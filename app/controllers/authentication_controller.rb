class AuthenticationController < Devise::SessionsController
  skip_before_action :check_sign_in_token, only: :create

  def create
    session[:return_to] = params[:return_to]
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
      session[:password_reset] = nil if user_signed_in?
      yield resource if block_given?
      
      # Update the IP address directly on the User object
      resource.update!(
        last_sign_in_at: DateTime.now,
        last_sign_in_ip: request.remote_ip,
        sign_in_count: resource.sign_in_count + 1
      )

      respond_with resource, location: after_sign_in_path_for(resource)
    else
      Rails.logger.info("User #{resource.email} is inactive.")
      sign_out(resource_name)
      redirect_to new_user_session_path, alert: "Contul dvs. este dezactivat. Vă rugăm să contactați administratorul."
    end
  end
  
end
