class CustomPasswordsController < Devise::PasswordsController
    before_action :clear_password_reset_session, only: [:resetareparola]
    skip_before_action :check_sign_in_token, only: [:update]

    def create
      self.resource = resource_class.send_reset_password_instructions(resource_params)
      puts('aaaaaaaaaaaa1')
      if successfully_sent?(resource)
        puts('aaaaaaaaaaaa2')
        session[:password_reset] = true
        session[:password_reset_done] = true
        Rails.logger.info("Set password reset session to: #{session[:password_reset]}")
        flash.discard # Discard the flash message before redirection
        redirect_to resetareparola_path
      else
        puts('aaaaaaaaaaaa3')
        respond_with(resource)
      end
      #session[:user_token] = current_user.generate_user_token
    end
    def update
        self.resource = resource_class.reset_password_by_token(reset_password_params)
        yield resource if block_given?
      
        if resource.errors.empty?
            session[:password_reset] = true
          resource.unlock_access! if unlockable?(resource)
          if Devise.sign_in_after_reset_password
            flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
            set_flash_message!(:notice, flash_message)
            resource.after_database_authentication
            sign_in(resource_name, resource)
            respond_with resource, location: after_resetting_password_path_for(resource)
          else
            set_flash_message!(:notice, :updated_not_active)
            respond_with resource, location: new_session_path(resource_name)
          end
        else
          set_minimum_password_length
          respond_with resource
        end
      end
      
 
    def edit
        puts("daaaa9")
        session[:password_reset] = true
        super
        puts("sesion= #{session[:password_reset]}")
        puts("daaaa10")
      end
  
    
    protected

    def after_resetting_password_path_for(resource)
        puts('aaaaaaaaaaaa77')
      flash[:notice] = "Parola a fost schimbată cu succes."
      root_path # returnează root_path în loc de nil
    end

    def after_sending_reset_password_instructions_path_for(resource_name)
        puts('aaaaaaaaaaaa78')
      root_path
    end
    def clear_password_reset_session
        puts('aaaaaaaaaaaa79')
        session[:password_reset] = nil if session[:password_reset]
      end
      def reset_password
        # Cod pentru resetarea parolei...
        puts('aaaaaaaaaaaa80')
        session[:password_reset] = true
        
      end
      def password_reset_done
        puts('aaaaaaaaaaaa81')
        # codul care se execută după resetarea cu succes a parolei
        session[:password_reset_done] = true
      end
      def reset_password_params
        params.require(:user).permit(:reset_password_token, :password, :password_confirmation)
      end
  end

  #####################
  