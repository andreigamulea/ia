require 'net/http'
require 'json'
require 'aws-sdk-s3'
  require 'open-uri'
  require 'net/ssh'
require 'net/sftp'
#require 'openssl'
class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:newsletter]
  before_action :set_user_admin, only: %i[panouadmin cazuriparticulare userip user77 listavegetalegratis]
  def index
    #render layout: false
  end
  def termeni_conditii
  end
  def politica_confidentialitate
  end    
  def politica_cookies
  end 
  def politica_gdpr
  end 
  def show_ip
    render plain: request.remote_ip
  end
  def test_ssl_connection
    url = 'https://www.google.com'  # Sau altă adresă HTTPS sigură
    uri = URI(url)
  
    # Configurează cererea HTTP
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    http.ca_file = Rails.root.join('cacert.pem').to_s  # Calea relativă către cacert.pem
  
    # Trimite cererea
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
  
    # Asigură-te că corpul răspunsului este codificat în UTF-8
    response_body_utf8 = response.body.force_encoding('UTF-8')
  
    # Afișează codul de răspuns și corpul răspunsului
    puts "Codul de răspuns: #{response.code}"
    puts "Corpul răspunsului: #{response_body_utf8}"
  
    # Render cu text în UTF-8
    render plain: "Cerere HTTPS funcționată cu succes! Codul de răspuns: #{response.code}"
  end
  
  #password = 'bhairava' # În producție folosește variabile de mediu pentru stocarea parolei.
  require 'net/ssh'
require 'net/sftp'

def test_debian
  ## Detalii conexiune SSH
  #ssh_host = 'ayush.go.ro'
  #ssh_port = 22
  #username = 'ayushayush'
  #password = 'Bhairava10.10'

  # Calea către fișierul encryption.key pe serverul Debian
  #key_file_path = '/mnt/AyushCell/encryption.key'

  @video_url_m3u8 = 'https://ayush.go.ro/Ormus/output.m3u8'
  #@video_url_m3u8 = 'https://ayush.go.ro/Cursuri/Rasayana/Modul 1/M01C01/output.m3u8'
  #@video_url_m3u8 = Video.last.link_debian


  #@video_url_m3u8 = Video.find_by(id: 347).link_debian
  @video_url = 'https://ayush.go.ro/natura1.mp4'
  # Mesaj de stare pentru M3U8
  #@message_m3u8 = ""
  #@encryption_key = ""

end

  
  

def get_encryption_key



  Rails.logger.info "Metoda get_encryption_key a fost apelată."
  response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
  response.headers["Pragma"] = "no-cache"
  response.headers["Expires"] = "0"

  #encryption_key = Rails.application.credentials[:encryption_key]
  encryption_key = "True            "
  

  if encryption_key.present?
    Rails.logger.info "Cheia de criptare este prezentă."
    render plain: encryption_key
  else
    Rails.logger.error "Cheia de criptare nu a fost găsită."
    render plain: "Cheia de criptare nu a fost găsită.", status: :not_found
  end
end
  
def proxy_video
  file_path = params[:path]
  token = params[:token]
  expires = params[:expires].to_i

  # Validează token-ul și expirarea
  encryption_key = priority_flag
  expected_token = OpenSSL::HMAC.hexdigest("SHA256", encryption_key, "#{file_path}#{expires}")

  if token == expected_token && Time.now.to_i < expires
    # Setează antetul X-Accel-Redirect pentru Nginx
    response.headers['X-Accel-Redirect'] = "/protected_video/#{file_path}"
    head :ok
  else
    render plain: "Acces interzis", status: :forbidden
  end
end


  
  
  
  def test_wasabi_access
    # Accesează credențialele Wasabi din Rails credentials
    aws_access_key_id = Rails.application.credentials.dig(:wasabi, :access_key_id)
    aws_secret_access_key = Rails.application.credentials.dig(:wasabi, :secret_access_key)

    if aws_access_key_id.nil? || aws_secret_access_key.nil?
      render plain: "Credențialele Wasabi nu sunt setate corect în credentials.yml.enc."
      return
    end

    # Configurare Wasabi S3 cu credențialele din Rails credentials
    Aws.config.update({
      region: 'eu-central-2',
      credentials: Aws::Credentials.new(aws_access_key_id, aws_secret_access_key),
      endpoint: 'https://s3.eu-central-2.wasabisys.com'
    })

    s3_bucket = 'ayushcell-videos'
    s3_key = 'test/Forest_Waterfall_Nature_Sounds_1_Hour_Relaxing_Birds_Chirping_River.mp4'

    begin
      # Obține clientul S3
      s3_resource = Aws::S3::Resource.new

      # Verifică dacă obiectul video există în bucket
      video_object = s3_resource.bucket(s3_bucket).object(s3_key)

      if video_object.exists?
        render plain: "Conexiunea la Wasabi a fost realizată cu succes și fișierul există!"
      else
        render plain: "Fișierul video nu există în Wasabi."
      end
    rescue Aws::S3::Errors::ServiceError => e
      render plain: "A apărut o eroare la accesarea Wasabi: #{e.message}"
    end
  end
  
  #s3_key = 'Forest_Waterfall_Nature_Sounds_1_Hour_Relaxing_Birds_Chirping_River.mp4'
  #subtitle_key = 'Forest_Waterfall_Nature_Sounds_1_Hour_Relaxing_Birds_Chirping_River.vtt'
  
  
  
  
  
    
  
  def test
    # Accesează credențialele Wasabi din Rails credentials
    aws_access_key_id = Rails.application.credentials.dig(:wasabi, :access_key_id)
    aws_secret_access_key = Rails.application.credentials.dig(:wasabi, :secret_access_key)
  
    if aws_access_key_id.nil? || aws_secret_access_key.nil?
      render plain: "Credențialele Wasabi nu sunt setate corect în credentials.yml.enc."
      return
    end
  
    # Configurare Wasabi S3 cu credențialele din Rails credentials
    Aws.config.update({
      region: 'eu-central-2',
      credentials: Aws::Credentials.new(aws_access_key_id, aws_secret_access_key),
      endpoint: 'https://s3.eu-central-2.wasabisys.com'
    })
  
    s3_bucket = 'ayushcell'
    s3_key_hls = 'Forest_Waterfall_Nature_Sounds_1_Hour_Relaxing_Birds_Chirping_River/output.m3u8'
    s3_key_encryption = 'encryption.key'
  
    begin
      s3_resource = Aws::S3::Resource.new
      video_object_hls = s3_resource.bucket(s3_bucket).object(s3_key_hls)
      encryption_key_object = s3_resource.bucket(s3_bucket).object(s3_key_encryption)
  
      if video_object_hls.exists? && encryption_key_object.exists?
        @message = "Playlistul HLS și fișierul encryption.key au fost găsite cu succes!"
  
        # Citește conținutul playlistului HLS
        playlist_content = video_object_hls.get.body.read
  
        # Debugging pentru fișierul encryption.key
        @encryption_key_debug = "Fișierul encryption.key există în Wasabi!"
  
        # Debugging pentru fragmente .ts
        @ts_files_debug = {}
        playlist_with_presigned_urls = playlist_content.gsub(/output\d{3}\.ts/) do |fragment_name|
          fragment_object = s3_resource.bucket(s3_bucket).object("Forest_Waterfall_Nature_Sounds_1_Hour_Relaxing_Birds_Chirping_River/#{fragment_name}")
        
          # Generează URL presemnat pentru fiecare fragment cu o valabilitate de 7 zile
          if fragment_object.exists?
            presigned_url = fragment_object.presigned_url(:get, expires_in: 604800)  # valabil 7 zile
            @ts_files_debug[fragment_name] = presigned_url
            presigned_url
          else
            @ts_files_debug[fragment_name] = "Fragmentul nu există!"
            "Fragmentul nu există!"
          end
        end
        
  
        # Codifică playlistul cu URL-uri presemnate în Base64 pentru player
        @playlist_with_presigned_urls = Base64.encode64(playlist_with_presigned_urls)
      else
        @message = "Playlistul HLS sau fișierul encryption.key nu există în Wasabi."
        @encryption_key_debug = "Fișierul encryption.key nu există în Wasabi!" if !encryption_key_object.exists?
      end
  
    rescue Aws::S3::Errors::ServiceError => e
      @message = "Eroare la accesarea Wasabi: #{e.message}"
    end
  
    render template: 'home/test'
  end
  
  
  
  
  
  # Generate presigned URL for encryption key
  def generate_presigned_key_url
    s3 = Aws::S3::Resource.new(
      region: 'eu-central-2',
      access_key_id: Rails.application.credentials.dig(:wasabi, :access_key_id),
      secret_access_key: Rails.application.credentials.dig(:wasabi, :secret_access_key),
      endpoint: 'https://s3.eu-central-2.wasabisys.com'
    )
  
    bucket = s3.bucket('ayushcell')  # Sau numele corect al bucket-ului tău
    key_object = bucket.object('encryption.key')
  
    begin
      # Generăm URL-ul presemnat pentru fișierul encryption.key
      presigned_url = key_object.presigned_url(:get, expires_in: 604800) # 7 zile
  
      # Debugging în consola serverului
      Rails.logger.info "Presigned URL generated: #{presigned_url}"
  
      # Returnează URL-ul presemnat în JSON
      render json: { url: presigned_url }
    rescue Aws::S3::Errors::ServiceError => e
      Rails.logger.error "Error generating presigned URL: #{e.message}"
      render json: { error: "Error generating presigned URL: #{e.message}" }, status: :internal_server_error
    end
  end
  
  
  
  
  
  
  
  
  
  
  
  
  def make_unlisted
    # Scopurile necesare pentru YouTube API
    scopes = ['https://www.googleapis.com/auth/youtube.force-ssl']
  
    # Obține token-ul de acces de la utilizatorul autentificat
    token = current_user.google_token
  
    # Asigură-te că token-ul este valid
    if token.nil?
      render json: { error: 'Token-ul de autentificare este invalid sau expirat.' }, status: :unauthorized
      return
    end
  
    # Configurează clientul YouTube folosind token-ul de acces al utilizatorului
    youtube_service = Google::Apis::YoutubeV3::YouTubeService.new
    youtube_service.authorization = token
  
    # ID-ul videoclipului pe care dorești să-l faci nelistat
    video_id = 'JdCDbM4gTwM'
  
    begin
      # Obține detaliile videoclipului
      video = youtube_service.list_videos('status', id: video_id).items.first
  
      if video
        # Schimbă confidențialitatea videoclipului la 'unlisted'
        video.status.privacy_status = 'unlisted'
  
        # Actualizează videoclipul cu noua setare
        youtube_service.update_video('status', video)
  
        # Returnează un mesaj de succes
        render json: { message: "Videoclipul cu ID #{video_id} a fost schimbat la 'unlisted'." }, status: :ok
      else
        render json: { error: "Videoclipul cu ID #{video_id} nu a fost găsit." }, status: :not_found
      end
  
    rescue Google::Apis::ClientError => e
      # Prinde orice eroare și afișează un mesaj
      render json: { error: "A apărut o eroare: #{e.message}" }, status: :unprocessable_entity
    end
  end
  
  
    
    
  
  def panouadmin
    @newsauupdate = 0 #acest cod este pt preluarea datelor de facturare pt an3 atat. 
    email_exists_in_listacanal3 = Listacanal3.exists?(email: current_user&.email)
    
    # Găsește înregistrarea DateFacturare pentru emailul utilizatorului curent, dacă există
    @date_facturare = DateFacturare.find_by(email: current_user&.email)
  
    if email_exists_in_listacanal3 || current_user.role == 1     
      if @date_facturare
        @newsauupdate = 2
      else  
        @newsauupdate = 1
      end  
    end  
  end
  def sesiune_vara_raport
    # Găsește toate evenimentele care conțin "action": "myvideo15"
    events = Ahoy::Event.where("properties @> ?", { action: "myvideo15" }.to_json)

    # Grupați evenimentele după `user_id` și numărați accesările
    user_access = events.group(:user_id).count

    # Obțineți numele utilizatorilor și numărul de accesări
    @user_reports = user_access.map do |user_id, numar_accesari|
      user = User.find_by(id: user_id)
      {
        user_id: user_id,
        nume: user&.name, # presupunând că coloana se numește `name`
        numar_accesari: numar_accesari
      }
    end

    # Numărul total de utilizatori care au accesat "myvideo15"
    @numar_utilizatori = @user_reports.count

    # Găsește userii care au cumpărat produsul cu codul "cod211"
    cod211_orders = ComenziProd.joins(:prod)
                               .where(prods: { cod: 'cod211' }, validat: 'Finalizata')
                               .pluck(:user_id)

    @users_with_cod211 = User.where(id: cod211_orders).pluck(:id, :name)

    # Găsește userii care au cumpărat cod211, dar nu au accesat myvideo15
    accessed_user_ids = @user_reports.map { |report| report[:user_id] }
    @users_purchased_but_not_accessed = User.where(id: cod211_orders - accessed_user_ids).pluck(:id, :name)
  end
 
  def resetareparola    
  end
  def cookiestest
  end
  def cazuriparticulare
  end  
  def copyright
  end  
  def documente
    @prod = Prod.where(curslegatura: 'documente', status: 'activ')
  end  
  def userip
    @userip= UserIp.all
  end  
  def user77
    users = User.all
    @aremail=[]
    
    users.each do |user|
      # Acțiuni pe care vrei să le faci pentru fiecare utilizator
      if user && user.valid_password?('')
        @aremail << user.email
      else
        # Parola nu este corectă
      end
    end    
  end  

  def sesiune_vara
    data_prag = Date.new(2024, 8, 1)
  
    if current_user
      puts("User logat: #{current_user.id}")
  
      if current_user.role == 1
        # Utilizator cu role 1 are acces direct la video-uri
        @has_access = true
        @valid_prods = ['cod211']
        @expired_prods = []
        all_purchased = ['cod211']
        @a_cumparat_macar_un_cod = true
        @prods = Prod.where(cod: 'cod211')
        @prods_cumparate = Prod.where(cod: all_purchased)
      else
        # Obține codurile produselor cumpărate și datele de început și sfârșit
        purchased_prods = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
                                     .joins(:prod)
                                     .where(prods: { curslegatura: 'sesiune_vara', status: 'activ' })
                                     .pluck('prods.cod', 'datainceput', 'datasfarsit')
  
        purchased_prods1 = ComenziProd1.where(user_id: current_user.id, validat: 'Finalizata')
                                       .joins(:prod)
                                       .where(prods: { curslegatura: 'sesiune_vara', status: 'activ' })
                                       .pluck('prods.cod', 'datainceput', 'datasfarsit')
  
        purchased_prods ||= []
        purchased_prods1 ||= []
  
        all_purchased_prods = purchased_prods + purchased_prods1
  
        puts("Produse cumpărate cu date: #{all_purchased_prods}")
  
        @valid_prods = all_purchased_prods.select { |_, datainceput, _| datainceput && datainceput + 60.days >= Date.today }.map(&:first)
        @expired_prods = all_purchased_prods.select { |_, datainceput, _| datainceput && datainceput + 60.days < Date.today }.map(&:first)
  
        puts("Produse valabile: #{@valid_prods}")
  
        all_purchased = all_purchased_prods.map(&:first).uniq
        @a_cumparat_macar_un_cod = all_purchased.any?
  
        if @a_cumparat_macar_un_cod
          @prods = Prod.none
          @has_access = true
        else
          @prods = Prod.where(cod: 'cod211')
        end
  
        @prods_cumparate = Prod.where(cod: all_purchased)
      end
  
      puts("Produse afișate: #{@prods.pluck(:cod) if @prods}")
      puts("Are acces? : #{@has_access}")
      puts("Produse cumpărate: #{@prods_cumparate.pluck(:cod) if @prods_cumparate}")
  
      @myvideo13 = if @a_cumparat_macar_un_cod
                     if current_user.limba == 'EN'
                       Video.where(tip: 'sesiune_vara').where('ordine > ? AND ordine < ?', 2000, 3000).order(ordine: :asc)
                     else
                       Video.none
                     end
                   else
                     Video.none
                   end
  
      if @has_access
        @platit = true
        puts("sunt in has acces")
        if current_user.limba == 'EN'
          puts("sunt in limba en")
          @myvideo = Video.where(tip: 'sesiune_vara').where('(ordine >= ? AND ordine <= ?)', 1000, 2000).order(ordine: :asc)
        else
          puts("NU sunt in limba en")
          @myvideo = Video.where(tip: 'sesiune_vara').where('ordine <= ?', 1000).order(ordine: :asc)
        end
        puts("Numarul: #{@myvideo.count}")
      else
        puts("sunt in has acces NU")
        @myvideo13 = Video.none
      end
    else
      ## Utilizator neautentificat
      puts("User nelogat")
      @prods = Prod.where(curslegatura: 'sesiune_vara', status: 'activ').where(cod: 'cod211').order(:id)
      @has_access = false
      @prods_cumparate = Prod.none
      @videos_correspondente = Video.none
      @myvideo13 = Video.none
      @a_cumparat_macar_un_cod = false
    end
  
    if data_prag
      puts("Data prag + 60 zile= : #{data_prag + 60.days}")
    end
      
  end
  
  
   

  def recuperare_cursuri
    # Listele de utilizatori
    an1 = ["aura.tiparu@gmail.com", "liveplaylovebetter@protonmail.com", "elena.riba7@yahoo.com", "v_ionela@yahoo.com"]
    an2 = ["cristinastanescu995@gmail.com", "delia_orita@yahoo.co.uk", "emilia777emi@gmail.com", "marianacuceu@yahoo.com",
           "crisgavrilescu707@gmail.com", "v_ionela@yahoo.com"]
    an3 = ["lumigriza@yahoo.com","ovidiu_popovici_vlad@yahoo.com", "ce.hermkens@gmail.com", "szabo.doina@yahoo.com", "crina_dora@yahoo.com"]
    an4 = ["sorincsv@yahoo.com", "fhun8@hotmail.com", "roalexis71@gmail.com", "florynn85@yahoo.com", "arthadora2012@gmail.com",
           "lidiaistodorescu@yahoo.com"]
  
    # Normalizează emailurile din liste
    an1.map!(&:strip).map!(&:downcase)
    an2.map!(&:strip).map!(&:downcase)
    an3.map!(&:strip).map!(&:downcase)
    an4.map!(&:strip).map!(&:downcase)
  
    # Normalizează emailul utilizatorului
    user_email = current_user.email.strip.downcase
  
    # Debugging pentru apartenență
    puts "Email utilizator: #{user_email}"
    puts "Este în an1? #{an1.include?(user_email)}"
    puts "Este în an2? #{an2.include?(user_email)}"
    puts "Este în an3? #{an3.include?(user_email)}"
    puts "Este în an4? #{an4.include?(user_email)}"
  
    # Distribuirea videoclipurilor
    video_links = {
      an1: 'S4C0zZW8Vvw',
      an2: 'ClYxngJ_Vm0',
      an3: 'ubItratex9I',
      an4: 'jHx5c6lOzVM'
    }
  
    if current_user
      user_videos = []
  
      # Asociere videoclipuri
      user_videos << video_links[:an1] if an1.include?(user_email)
      user_videos << video_links[:an2] if an2.include?(user_email)
      user_videos << video_links[:an3] if an3.include?(user_email)
      user_videos << video_links[:an4] if an4.include?(user_email)
  
      # Debugging pentru videoclipuri asociate
      puts "Videoclipuri utilizator: #{user_videos.inspect}"
  
      # Eliminăm duplicatele
      unique_videos = user_videos.uniq
  
      if unique_videos.any?
        # Creăm expresia CASE pentru ordonare
        order_sql = unique_videos.each_with_index.map { |v, i| "WHEN '#{v}' THEN #{i}" }.join(' ')
        @myvideo = Video
                     .where(link: unique_videos)
                     .select("DISTINCT ON (link) *")
                     .order(Arel.sql("link, CASE link #{order_sql} END, created_at DESC"))
      else
        @myvideo = Video.none
      end
    else
      @myvideo = Video.none
    end
  end
  
  
  
  
  
  
  
  
  

  def newsletter #este o metoda de tip POST
    Rails.logger.debug "Params: #{params.inspect}"
  
    newsletter = Newsletter.new(newsletter_params)
    if newsletter.save
      render json: { message: "Înscriere reușită!" }, status: :created
    else
      render json: { errors: newsletter.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def lista_newsletter #afiseaza pe cei inscrisi
    if current_user && current_user.role==1
      @lista = Newsletter.all
      @n=0
      @nr_inscrisi=@lista.count
    else
      redirect_to root_path
    end  
  end  
 
  def rasayana
    @has_access = current_user&.role == 1
  
    # Verifică dacă userul curent există în UserModulecursuri cu condițiile specificate
    if current_user
      @has_access ||= UserModulecursuri.exists?(user_id: current_user.id, 
                                                modulecursuri_id: 3, 
                                                validat: "Finalizata")
    end
    @condition1 = if current_user
      if current_user.role == 1
        true
      else
        comanda = ComenziProd.where(user_id: current_user.id, validat: "Finalizata")
                            .where(prod_id: Prod.where(cod: ['cod72', 'cod74']).select(:id))
                            .order(datasfarsit: :desc)
                            .first
    
        if comanda && comanda.datasfarsit
          comanda.datasfarsit >= Date.today
        else
          false
        end
      end
    end
    
    
    
    if @has_access
      @myvideo4 = Video.where(tip: 'nutritie2').where('ordine > ? AND ordine < ?', 3000, 4000).order(ordine: :asc)
  
    end  
    if !current_user      
      @prods = Prod.where(curslegatura: 'nutritie2', status: 'activ', cod: 'cod72')
    elsif current_user && @has_access && @condition1
      @prods = Prod.none
      @platit=true # variabila care permite accesul la video
      @myvideo = Video.where(tip: 'nutritie2').where('ordine > ? AND ordine < ?', 0, 1000).order(ordine: :asc)  
    elsif @has_access
      
      @prods = Prod.where(curslegatura: 'nutritie2', status: 'activ', cod: 'cod74')
    else
      @prods = Prod.where(curslegatura: 'nutritie2', status: 'activ', cod: 'cod72')
    end
  end  
 
  

 
  def listavegetalegratis
    @acces = params[:acces]
    @mesaj1 = "Acces gratuit 24h"
    @mesaj2 = "Cautare selectiva in lista de ingrediente vegetale"
    if @acces == "da"
      redirect_to lista_vegetales_path
    elsif @acces == "nu" && current_user
      produs = "Lista vegetale"
  
      curs_exists = current_user.cursuri.any? { |curs| curs.listacursuri.nume == produs && (curs.datasfarsit.nil? || Date.current <= curs.datasfarsit) }
      Rails.logger.info "Curs exists?: #{curs_exists}"
      puts("intraaaaaaa")
      puts(current_user.id)
      unless curs_exists || UserIp.exists?(user_id: current_user.id, curspromo: produs) || UserIp.exists?(ip_address: current_user.last_sign_in_ip, curspromo: produs)
        curs_id = Listacursuri.find_by(nume: produs).id
        curs = Cursuri.find_or_initialize_by(listacursuri_id: curs_id, user_id: current_user.id)
        puts("daaaaaaaaaaa")
        curs.update!(
          datainceput: Time.now,
          datasfarsit: Time.now + 1.day,
          sursa: 'Promo 24h'
        )
        UserIp.create!(user_id: current_user.id, ip_address: current_user.last_sign_in_ip, curspromo: produs)
  
        # Adding entry to CursuriHistory
        CursuriHistory.create!(
          user_id: current_user.id,
          listacursuri_id: curs_id,
          cursuri_id: curs.id,
          datainceput: curs.datainceput,
          datasfarsit: curs.datasfarsit,
          email: current_user.email, # assuming the user model has an email attribute
          modificatde: 'Promo 24h'
        )
      else
        redirect_to servicii_path
      end
    end
  end
  
  
  
  
  def mergi
     @mesaj = params[:mesaj]
  end  
  def successtripe
    session_id = params[:session_id]
    @stripe_session = Stripe::Checkout::Session.retrieve(session_id)  
  
    # Data și ora tranzacției:
    @data_creare = Time.at(@stripe_session.created).to_datetime
    @data_creare_formatata = @data_creare.strftime('%d-%m-%Y %H:%M')
  
    # Suma achitată:
    id_produs = @stripe_session.metadata['id_produs'].to_i
    produs = Prod.find(id_produs)  # Presupunem că modelul 'Prod' are o coloană 'pret'
    @suma_achitata = @stripe_session.metadata[:pret_total]
    @redirect_spre = produs.curslegatura
    if ('cod14'..'cod37').include?(produs.cod)
      @redirect_spre='cursayurveda'
    end  
    # Metoda de plată utilizată:
    @metoda_plata = @stripe_session.payment_method_types[0]  # Presupunem că există o singură metodă de plată
  
    # Numărul de referință al tranzacției:
    @numar_referinta = @stripe_session.metadata['numar_comanda']
  
    # Aici poti afisa sau redirecta catre view-ul tau
    # ...
  end
  
  

  
  def servicii
    emailuri_promo = ["test@yahoo.com"]
  
    if user_signed_in?
      if emailuri_promo.include?(current_user.email)
        @prods = Prod.where(cod: 'cod314').order(:id)
      elsif current_user.role == 1
        @prods = Prod.where(curslegatura: 'Lista vegetale', status: 'activ').order(:id)
      else
        @prods = Prod.where(curslegatura: 'Lista vegetale', status: 'activ')
                     .where.not(cod: 'cod314')
                     .order(:id)
      end
    else
      @prods = Prod.where(curslegatura: 'Lista vegetale', status: 'activ')
                   .where.not(cod: 'cod314')
                   .order(:id)
    end
  end
  

  
  
  
  
  
  def tabeleahoy
    if current_user.role==1
    @ahoy_visits = Ahoy::Visit.order(started_at: :desc).limit(30).includes(:user).reverse
    @ahoy_events = Ahoy::Event.order(time: :desc).limit(7000).includes(:user)
    @ahoy_events = @ahoy_events.map do |event|
      event.properties = event.properties[0..99] if event.properties.present?
      event
    end.reverse
    
    end

  end
  
  def contact
    
    if request.post?
      name = params[:name]
      email = params[:email]
      message = params[:message]

      if name.present? && email.present? && message.present?
        if valid_email?(email)
          ContactMailer.contact_email(name, email, message).deliver_now
          redirect_to contact_path, notice: "Mesajul a fost trimis cu succes!"
        else
          flash.now[:error] = "Adresa de email nu este validă!"
        end
      else
        flash.now[:error] = "Toate câmpurile trebuie completate!"
      end
    end
  
  end
  def export_newsletter_subscribers
    subscribers = Newsletter.all.order(:id)  # Assuming you want to export all records

    # Create a new workbook
    workbook = RubyXL::Workbook.new
    worksheet = workbook[0]
    worksheet.sheet_name = 'Subscribers'

    # Define headers for the spreadsheet
    headers = ['ID', 'Name', 'Email']
    headers.each_with_index do |header, index|
      worksheet.add_cell(0, index, header)
    end

    # Fill the spreadsheet with subscriber data
    subscribers.each_with_index do |subscriber, index|
      worksheet.add_cell(index + 1, 0, subscriber.id)
      worksheet.add_cell(index + 1, 1, subscriber.nume)
      worksheet.add_cell(index + 1, 2, subscriber.email)
    end

    # Save the workbook to a file
    file_path = Rails.root.join('tmp', 'newsletter_subscribers.xlsx')
    workbook.write(file_path)

    # Send the file to the user
    send_file(file_path, filename: 'newsletter_subscribers.xlsx', type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
  end
  private

  def valid_email?(email)
    # Utilizează o expresie regulată sau o altă metodă pentru a verifica validitatea adresei de email
    # Aici este un exemplu simplu utilizând expresii regulate
    email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    !!(email =~ email_regex)
  end
  def set_user_admin
    if !current_user
      redirect_to root_path, alert: "Nu ai permisiunea de a accesa această pagină."
      return
    end  
    unless current_user.role == 1
      redirect_to root_path, alert: "Nu ai permisiunea de a accesa această pagină."
      return
    end
  end
  def newsletter_params
    params.require(:newsletter).permit(:nume, :email, :validat)
  end
  def test_file_access(url)
    require 'net/http'
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    [response.is_a?(Net::HTTPSuccess), response] # Returnează atât rezultatul testului, cât și răspunsul complet
  end
  
  
end
