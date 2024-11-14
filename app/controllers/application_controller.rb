class ApplicationController < ActionController::Base
    rescue_from ActiveRecord::RecordNotFound, with: :redirect_to_root
    rescue_from ActionController::RoutingError, with: :redirect_to_root
    puts("111111")
    before_action :set_facturare_access
    before_action :redirect_if_exists, if: :date_facturare_controller?
    before_action :track_ahoy_visit
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :check_user_active
    skip_before_action :check_user_active, only: [:after_sign_in_path_for]
    before_action :check_sign_in_token
    before_action :set_stripe_key
    before_action :set_security_headers

    def set_security_headers
      response.headers['X-Frame-Options'] = 'DENY'
      response.headers['X-XSS-Protection'] = '1; mode=block'
      response.headers['X-Content-Type-Options'] = 'nosniff'
      response.headers['Referrer-Policy'] = 'strict-origin-when-cross-origin'
      response.headers['Permissions-Policy'] = 'geolocation=(), camera=(), microphone=()'
    end




    puts("22222222")
    def handle_routing_error
      redirect_to cursayurveda2425_path, alert: "No route matches for this request."
    end
  
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
      puts("3333")
      unless request.path.start_with?('/assets', '/thumbnails')
        RedirectionLog.create(original_path: request.fullpath, redirected_to: root_path)
      end
      redirect_to root_path
    end


    require 'jwt'

SECRET_KEY = "secretkey1"  # Cheia setată direct în cod

# Generăm un token cu o valabilitate mai mare (de exemplu, 30 de minute)
def generate_persistent_token
  payload = { exp: 30.minutes.from_now.to_i }
  JWT.encode(payload, SECRET_KEY, 'HS256')
end

def priority_flag
  response.set_header('Access-Control-Allow-Origin', '*')
  response.set_header('Access-Control-Allow-Methods', 'GET, OPTIONS')
  response.set_header('Access-Control-Allow-Headers', 'Authorization, Content-Type')

  token = params[:token]

  unless token
    # Generează un token cu valabilitate extinsă
    persistent_token = generate_persistent_token
    render plain: "Link de acces: https://ayushcell.ro/priority_flag?token=#{persistent_token}", status: :unauthorized
    return
  end

  # Verifică token-ul utilizând SECRET_KEY
  begin
    JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS256' })
    # Dacă token-ul este valid, returnează cheia "True"
    encryption_key = "True            "
    render plain: encryption_key
  rescue JWT::ExpiredSignature
    render plain: "Token expirat", status: :unauthorized
  rescue JWT::DecodeError
    render plain: "Token invalid", status: :unauthorized
  end
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
      puts("4444patru")
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
        puts("asaaaaaaaaaaa")
        if pagina
          puts("bbbbbbbbbbbbbbb")
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
        elsif return_to == "tayv24"         
          tayv24_path
        elsif return_to == "tayt24"         
          tayt24_path
        elsif return_to == "sesiune_vara"         
          sesiune_vara_path
        elsif return_to == "taxainscriere" 
          cursayurveda2425_path
        elsif return_to == "cay2425"
          cursayurveda2425_path  
        elsif return_to == "traditia_ayurvedica" 
          traditia_ayurvedica_path
        elsif return_to == "jivaka" 
          jivaka_path  
        elsif return_to == "asita" 
          asita_path  
        elsif return_to == "jamadagni" 
          jamadagni_path  
        elsif return_to == "hiranyaksha" 
          hiranyaksha_path
        elsif return_to == "sharaloma" 
          sharaloma_path
        elsif return_to == "saunaka" 
          saunaka_path
        elsif return_to == "maudgalya" 
          maudgalya_path
        elsif return_to == "nimi" 
          nimi_path
        elsif return_to == "vajikarana" 
          vajikarana_path  
        elsif return_to == "cognitronica"   
          cognitronica_path
        elsif return_to == "vajikarana1"   
          vajikarana_modul1_path 
        elsif return_to == "rasayana1"   
          rasayana_modul1_path  
        elsif return_to == "optimizarea_performanțelor_cognitive" 
          optimizarea_performantelor_cognitive_path
        elsif return_to == "voluntar" 
          voluntar_path
        elsif return_to == "voluntariat" 
          voluntariat_path  
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
      
      
      def set_facturare_access
        return unless current_user  # Asigură-te că avem un utilizator conectat
    
        email_exists_in_listacanal3 = Listacanal3.exists?(email: current_user.email)
        @date_facturare = DateFacturare.find_by(email: current_user.email)
    
        if email_exists_in_listacanal3 || current_user.role == 1
          @newsauupdate = @date_facturare ? 2 : 1
        else
          @newsauupdate = 0
        end
        puts("Vloarea lui @newsauupdate este #{@newsauupdate}")
      end

      def redirect_if_exists
        # Asigură-te că logica este aplicată numai când utilizatorul este logat
        return unless current_user
    
        ## Asumând că logica de verificare este specifică pentru anumite acțiuni din controlerul DateFacturares
        if controller_name == 'date_facturares' && action_name == 'new'
          existing_facturare = DateFacturare.find_by(email: current_user.email)
          redirect_to edit_date_facturare_path(existing_facturare) if existing_facturare
        end
      end
    
      def date_facturare_controller?
        # Aici poți defini condiții sub care logica să fie aplicată,
        # de exemplu, numai pentru controlerul DateFacturares
        controller_name == 'date_facturares'
      end
      
      
end
