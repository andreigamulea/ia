class ApplicationController < ActionController::Base
    rescue_from ActiveRecord::RecordNotFound, with: :redirect_to_root
    rescue_from ActionController::RoutingError, with: :redirect_to_root
    before_action :track_ahoy_visit
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :check_user_active
    skip_before_action :check_user_active, only: [:after_sign_in_path_for]
    before_action :check_sign_in_token
    before_action :set_stripe_key
    def luna_in_romana(luna_engleza)
      traduceri = {
        "January" => "ianuarie",
        "February" => "februarie",
        "March" => "martie",
        "April" => "aprilie",
        "May" => "mai",
        "June" => "iunie",
        "July" => "iulie",
        "August" => "august",
        "September" => "septembrie",
        "October" => "octombrie",
        "November" => "noiembrie",
        "December" => "decembrie"
      }
    
      traduceri[luna_engleza] || luna_engleza
    end
    
    def track_ahoy_visit
      return if @skip_tracking
  
      ahoy.track "Processed #{controller_name}##{action_name}", request.filtered_parameters
    end
    def redirect_to_root
      unless request.path.start_with?('/assets', '/thumbnails')
        RedirectionLog.create(original_path: request.fullpath, redirected_to: root_path)
      end
      redirect_to root_path
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
    def redirect_to_root
      @skip_tracking = true
      redirect_to root_path
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
        
        Rails.logger.info "Aici, return_to1: #{params[:return_to]}"
        Rails.logger.info "Aici, session.delete(:user_return_to): #{session.delete(:user_return_to)}"
        #Explicatie: la sign_up return_to vine de la session.delete(:user_return_to iar 
        #la sign_in de la request.env.dig('omniauth.params', 'return_to') sau de la params[:return_to]
        #asa ca pot de acum folosi parametrul return_to si la sign_up care ma va duce tot aici la aceasta metoda.
        #nu am nevoie de o metoda noua  def after_sign_up_path_for(resource)

        return_to = session.delete(:user_return_to) || request.env.dig('omniauth.params', 'return_to') || params[:return_to]
  

        Rails.logger.info "Aici, return_to2: #{return_to}"

        if return_to == "menu"
          # Cod pentru cazul în care sursa este meniul
          root_path # Înlocuiește cu calea corespunzătoare
        elsif return_to == "vn"
          # Cod pentru cazul în care sursa este butonul
          valorinutritionales_path # Înlocuiește cu calea corespunzătoare
        elsif return_to == "aplicatie nutritie"
          # Cod pentru cazul în care sursa este butonul
          aplicatie_path # Înlocuiește cu calea corespunzătoare
        elsif return_to == "lg"
          # Cod pentru cazul în care sursa este butonul
          lista_vegetales_path # Înlocuiește cu calea corespunzătoare
        elsif return_to == "nutritie1"
          # Cod pentru cazul în care sursa este butonul
          nutritie1_path # Înlocuiește cu calea corespunzătoare  
        elsif return_to == "testnutritie4"
          # Cod pentru cazul în care sursa este butonul
          testnutritie4_path # Înlocuiește cu calea corespunzătoare  
        elsif return_to == "nutritie2"
          # Cod pentru cazul în care sursa este butonul
          nutritie2_path # Înlocuiește cu calea corespunzătoare  
        elsif return_to == "testnutritie2"
          # Cod pentru cazul în care sursa este butonul
          testnutritie2_path # Înlocuiește cu calea corespunzătoare  
        elsif return_to == "nutritie3"
          # Cod pentru cazul în care sursa este butonul
          nutritie3_path # Înlocuiește cu calea corespunzătoare 
        elsif return_to == "nutritie4"
          # Cod pentru cazul în care sursa este butonul
          nutritie4_path # Înlocuiește cu calea corespunzătoare 
        elsif return_to == "tayv2"
          # Cod pentru cazul în care sursa este butonul
          tayv2_path # Înlocuiește cu calea corespunzătoare  taxainscriere
        elsif return_to == "taxainscriere" 
          cursayurveda_path
        elsif return_to == "traditia_ayurvedica" 
          traditia_ayurvedica_path
        elsif return_to == "jivaka" 
          jivaka_path  
        elsif return_to == "vajikarana" 
          vajikarana_path  
        elsif return_to == "cognitronica"   
          cognitronica_path
        elsif return_to == "optimizarea_performanțelor_cognitive" 
          optimizarea_performanțelor_cognitive_path
        elsif return_to == "evaluaretipologie" 
          evaluare_tipologie_ayurvedica_path  
        elsif return_to == "tri" 
          tayt12_transport_international_path(return_to: 'tri')
        elsif return_to == "link1"
          # Cod pentru cazul în care sursa este link1
          video_link_path # Înlocuiește cu calea corespunzătoare pentru link1
      
        else
          # Dacă nu există parametru return_to, sau dacă valoarea acestuia nu este recunoscută, redirectează către o cale implicită
          root_path # Înlocuiește cu calea implicită
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
        Rails.logger.info("Inside check_sign_in_token. password reset: #{session[:password_reset]}")
        Rails.logger.info("Checking sign in token. User signed in: #{user_signed_in?}, password reset: #{session[:password_reset]}")
        if user_signed_in? && !session[:password_reset] && !current_user.signed_in_on_this_device?(session[:user_token])
          Rails.logger.info("Signing out user due to sign in on different device.")
          sign_out(current_user)
          flash[:alert] = "Ati fost deconectat deoarece v-ati autentificat pe un alt dispozitiv."
          redirect_to new_user_session_path
        end
      end
      
      
 

  
      
      
end
