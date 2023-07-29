#class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    
    skip_before_action :verify_authenticity_token, only: :google_oauth2
    def google_oauth2
        request.env['omniauth.params']
        return_to = request.env['omniauth.params']['return_to']
        puts("aaaaaaaaaaa")
        puts(return_to)
        puts("aaaaaaaaaaa")
         # You need to implement the method below in your model (e.g. app/models/user.rb)
        @user = User.from_omniauth(request.env["omniauth.auth"])

        if @user.persisted?
            new_token = SecureRandom.hex
            @user.update!(current_sign_in_token: new_token)  # generează un nou token la fiecare autentificare
            session[:user_token] = new_token  # actualizează tokenul în sesiune
      
            
            

        sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
        set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
        else
        session["devise.google_data"] = request.env["omniauth.auth"].except(:extra) # Removing extra as it can overflow some session stores
        redirect_to new_user_registration_url
        end
    end  
    def failure
        redirect_to root_path
      end
      def passthru
        session[:return_to] = params[:return_to]
        super
      end
end
