class ApplicationController < ActionController::Base
    before_action :track_ahoy_visit
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :check_user_active
    skip_before_action :check_user_active, only: [:after_sign_in_path_for]
    before_action :check_sign_in_token
    before_action :set_stripe_key
    def track_ahoy_visit
      ahoy.track "Processed #{controller_name}##{action_name}", request.filtered_parameters
    end   
    protected
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:email,:name, :role, :gdpr])
        devise_parameter_sanitizer.permit(:account_update, keys: [:email,:name, :role, :gdpr])
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
      def after_sign_in_path_for(resource)
        Rails.logger.info "In after_sign_in_path_for, user id: #{resource.id}"
        pagina = Paginisite.find_by(nume: "Login")
      
        if pagina
          user_pagina = UserPaginisite.new(user_id: resource.id, paginisite_id: pagina.id)
          if user_pagina.save
            Rails.logger.info "Created UserPaginisite record for user id: #{resource.id} and pagina id: #{pagina.id}"
          else
            Rails.logger.error "Failed to create UserPaginisite record: #{user_pagina.errors.full_messages.join(", ")}"
          end
        else
          Rails.logger.info "Pagina with name 'Login' not found"
        end
        puts "aici"
        
        Rails.logger.info "Aici, return_to: #{params[:return_to]}"
        if params[:return_to] == "menu"
          # Cod pentru cazul în care sursa este meniul
          root_path # Înlocuiește cu calea corespunzătoare
        elsif params[:return_to] == "vn"
          # Cod pentru cazul în care sursa este butonul
          valorinutritionales_path # Înlocuiește cu calea corespunzătoare
        elsif params[:return_to] == "lg"
          # Cod pentru cazul în care sursa este butonul
          lista_vegetales_path # Înlocuiește cu calea corespunzătoare
        else
          # Dacă nu există parametru return_to, sau dacă valoarea acestuia nu este recunoscută, redirectează către o cale implicită
          servicii_path # Înlocuiește cu calea implicită
        end
      end
     
     

      def set_stripe_key
        if Rails.env.development?
          @stripe_public_key = Rails.application.credentials.dig(:stripe, :development,  :publishable_key)
          @stripe_secret_key = Rails.application.credentials.dig(:stripe, :development,  :secret_key)
        elsif Rails.env.production?
          @stripe_public_key = Rails.application.credentials.dig(:stripe, :production,  :publishable_key)
          @stripe_secret_key = Rails.application.credentials.dig(:stripe, :production,  :secret_key)
        end
      end
      def check_sign_in_token
        if user_signed_in? && !current_user.signed_in_on_this_device?(session[:user_token])
          sign_out(current_user)
          flash[:alert] = "Ati fost deconectat deoarece v-ati autentificat pe un alt dispozitiv."
          redirect_to new_user_session_path
        end
      end
      
      
     
      
      
end
