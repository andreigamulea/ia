class VideosController < ApplicationController
  require 'date'

  before_action :set_video, only: %i[ show edit update destroy ]
  before_action :set_user, only: %i[ show edit update destroy]
  before_action :set_user1, only: %i[tayv2 myvideo1] #este pt tayv2
  before_action :set_user2, only: %i[myvideo2] #este pt nutritie3
  before_action :set_user7, only: %i[myvideo7] #este pt nutritie3 pt video de la Resurse si Aspecte organizatorice
  before_action :set_user6, only: %i[myvideo6] #este pt nutritie2 cursuri pregatitoare-slidere
  before_action :set_user67, only: %i[myvideo67] #este pt nutritie2 cursuri video
  before_action :set_user8, only: %i[myvideo8] #este pt nutritie1 cursuri pregatitoare-slidere
  before_action :set_user9, only: %i[myvideo9] #este pt nutritie1 cursuri video
  before_action :set_user3, only: %i[myvideo3] #este pt an1
  before_action :set_user4, only: %i[myvideo4] #este pt tayt12
  before_action :set_user44, only: %i[myvideo44] #este pt tayt12 p2 
  before_action :set_user444, only: %i[myvideo444] #este pt tayt12 video introductive la liber pt cei care au achitat doar tabara
  #before_action :set_user4, only: %i[myvideo5] #este pt tayt122 folosesc tot set_user4 pt ca e aceeasi plata si la tayt12 si la tayt122
  before_action :set_user11, only: %i[myvideo11] #pt nimi jivaka si cognitronica si performanta_cognitiva saunaka si hiranyaksha
  #ATENTIE POT FOLOSI set_user11, only: %i[myvideo11]  PT ORICE VIDEO INDIVIDUAL CARE ARE PRET- gen: video asociat cu produs cu pret=12lei
  
  before_action :set_user12, only: %i[myvideo12] ##pt nutritie4 
  before_action :set_user122, only: %i[myvideo122] ##pt nutritie4 aspecte organizatorice
  before_action :set_user13, only: %i[myvideo13] #este pt vajikarana1
  before_action :set_user133, only: %i[myvideo133] #este pt vajikarana1 resurse
  before_action :set_user14, only: %i[myvideo14] #este pt tayv24 video principale
  before_action :set_user144, only: %i[myvideo144] #este pt recuperare 2 cursuri an1,2,3 pt cei care au fost la tayv24
  before_action :set_user15, only: %i[myvideo15] #este pt sesiune_vara video principale
  before_action :set_user16, only: %i[myvideo16] #este pt an2 2024-2025
  before_action :set_user17, only: %i[myvideo17] #este pt an3 2024-2025
  before_action :set_user18, only: %i[myvideo18] #este pt an4 2024-2025
  before_action :set_user19, only: %i[myvideo19] #este pt rasayana modul 1
  before_action :set_user20, only: %i[myvideo20] #este pt an1 2024-2025
  before_action :set_user21, only: %i[myvideo21] #este pt revizionari an 3 24-25
  before_action :set_user22, only: %i[myvideo22] #este pt revizionari an 4 24-25
  before_action :set_user23, only: %i[myvideo23] #este pt tayt24
  before_action :require_admin, only: %i[index new edit update create]  
  # GET /videos or /videos.json
  def index
    @videos = Video.all
  end
  def linkocazional  
   
    # Verifică dacă utilizatorul este autentificat
    unless current_user        
        redirect_to new_user_session_path(return_to: 'link1')
        return # Opriți execuția metodei aici
    end
    
    allowed_emails = ['piharadita@yahoo.com']
    unless (allowed_emails.include?(current_user.email) || current_user.role == 1) && Date.current <= Date.parse("2023-11-01")
      redirect_to root_path, alert: "Acces neautorizat!"
      return
    end
  
    @myvideo1 = Video.find_by(tip: "linkocazional")
    @myvideo = @myvideo1[:link] if @myvideo1
    render 'myvideo1'
end

  
  
  def myvideo   
    @myvideo = Video.first.link    
  end
  def myvideo1
    @myvideo1 = Video.find(params[:id])
    @myvideo = Video.find(params[:id])[:link]
  end

  def tayv2
    @myvideo = Video.where(tip: 'tayv2').order(ordine: :asc)
  end
  def tayt12
    #@prod_tayt12 = Prod.where(curslegatura: 'tayt12').order(:cod)
    @prod_tayt12 = Prod.where(curslegatura: 'tayt12', status: 'activ').order(:cod)
    #@myvideo = Video.where(tip: 'tayt12').order(ordine: :asc)
    @myvideo = Video.where(tip: 'tayt12').where("ordine < ?", 1000).order(ordine: :asc)
    @myvideo3 = Video.where(tip: 'tayt12').where("ordine > ? AND ordine < ?", 3000, 4000).order(ordine: :asc)
    if current_user && current_user.limba=="EN"
      @myvideo4 = Video.where(tip: 'tayt12').where("ordine > ? AND ordine < ?", 5000, 6000).order(ordine: :asc)
    else
       @myvideo4 = Video.where(tip: 'tayt12').where("ordine > ? AND ordine < ?", 4000, 5000).order(ordine: :asc)
    end
    #@myvideo2 = Video.where(tip: 'tayt12').where("ordine > ?", 1000).order(ordine: :asc)
    if current_user && current_user.limba=="EN"
      @myvideo2 = Video.where(tip: 'tayt12').where("ordine > ? AND ordine < ?", 2000, 3000).order(ordine: :asc)
    else  
      @myvideo2 = Video.where(tip: 'tayt12').where("ordine > ? AND ordine < ?", 1000, 2000).order(ordine: :asc)
    end  

    if current_user
      @has_access = current_user.role == 1 || ComenziProd.joins(:prod)
      .where(user_id: current_user.id, prods: { cod: ["cod40", "cod41", "cod42", "cod43", "cod44", "cod45"] }, validat: "Finalizata").exists?
            
    else
      @has_access=false
    end  

    

    #@has_access_cursuri = ComenziProd.exists?(user_id: current_user.id, prod_id: 56)
    #verific daca userul poate vedea videourile taberei(a platit?)
    if current_user
      prod_id_cod54 = Prod.find_by(cod: 'cod54')&.id
      prod_id_cod64 = Prod.find_by(cod: 'cod64')&.id
    
      @has_access_cursuri = current_user.role == 1 || (
        (prod_id_cod54 && 
         ComenziProd.where(user_id: current_user.id, prod_id: prod_id_cod54, validat: 'Finalizata')
                    .where('datasfarsit >= ?', Date.current)
                    .exists?) ||
        ComenziProd.joins(:prod)
                   .where(user_id: current_user.id, prods: { cod: ["cod41", "cod43", "cod45"] }, validat: 'Finalizata')
                   .where('datainceput >= ?', '2024-01-31')
                   .where('datasfarsit >= ?', Date.current)
                   .exists?
      )
      puts("@has_access_cursuri este: #{@has_access_cursuri}")
    
      @has_access_cursuri2 = current_user.role == 1 || (
        (prod_id_cod64 && 
         ComenziProd.where(user_id: current_user.id, prod_id: prod_id_cod64, validat: 'Finalizata')
                    .where('datasfarsit >= ?', Date.current)
                    .exists?) ||
        ComenziProd.joins(:prod)
                   .where(user_id: current_user.id, prods: { cod: ["cod40", "cod42", "cod44"] }, validat: 'Finalizata')
                   .where('datainceput >= ?', '2024-01-31')
                   .where('datasfarsit >= ?', Date.current)
                   .exists?
      )
      puts("@has_access_cursuri2 este: #{@has_access_cursuri2}")
    end
    
    
    
    
    
    
    
    Rails.logger.info("Avem @has_access_cursuri2=true") if @has_access_cursuri2
    
    
    if current_user && ComenziProd.joins(:prod)
      .where(user_id: current_user.id, prods: { cod: ['cod40', 'cod41', 'cod42', 'cod43', 'cod44', 'cod45'] }, validat: 'Finalizata')
      .where('datainceput >= ?', '2024-01-31')
      .where('datasfarsit >= ?', Date.current)
      .exists?
     @has_access = true
     @prod_tayt12a = Prod.where(cod: ['cod40', 'cod41', 'cod42', 'cod43', 'cod44', 'cod45'], status: 'activ').order(:luna)
   elsif !@has_access
     @prod_tayt12a = Prod.where(cod: ['cod40', 'cod41','cod42','cod43', 'cod44','cod45'], status: 'activ').order(:luna)
   else
     if !@has_access_cursuri && !@has_access_cursuri2
       @prod_tayt12a = Prod.where(cod: ['cod54', 'cod64'], status: 'activ').order(:cod)
     elsif @has_access_cursuri && !@has_access_cursuri2
       @prod_tayt12a = Prod.where(cod: 'cod64', status: 'activ').order(:cod)
     elsif !@has_access_cursuri && @has_access_cursuri2
       @prod_tayt12a = Prod.where(cod: 'cod54', status: 'activ').order(:cod)
     elsif @has_access_cursuri && @has_access_cursuri2
       @prod_tayt12a = Prod.none
     end
   end
   
    

  end
  def tayt122
    @prod_tayt12 = Prod.where(curslegatura: 'tayt12').order(:cod)
    #@myvideo = Video.where(tip: 'tayt12').order(ordine: :asc)
    @myvideo = Video.where(tip: 'tayt12').where("ordine < ?", 1000).order(ordine: :asc)
    
    #@myvideo2 = Video.where(tip: 'tayt12').where("ordine > ?", 1000).order(ordine: :asc)
    if current_user && current_user.limba=="EN"
      @myvideo2 = Video.where(tip: 'tayt12').where("ordine > ? AND ordine < ?", 2000, 3000).order(ordine: :asc)
    else  
      @myvideo2 = Video.where(tip: 'tayt12').where("ordine > ? AND ordine < ?", 1000, 2000).order(ordine: :asc)
    end  

    if current_user
      @has_access = current_user.role == 1 || ComenziProd.joins(:prod)
      .where(user_id: current_user.id, prods: { cod: ["cod40", "cod41", "cod42", "cod43", "cod44", "cod45"] }, validat: "Finalizata").exists?
            
    else
      @has_access=false
    end  
    #@has_access_cursuri = ComenziProd.exists?(user_id: current_user.id, prod_id: 56)
    #verific daca userul poate vedea videourile taberei(a platit?)
    @has_access_cursuri = current_user && (current_user.role == 1 || ComenziProd.exists?(user_id: current_user.id, prod_id: 56))


  end
  ############################ in metoda de mai jos sunt pt nutritie3 
  #daca vreau pt alte cursuri duplic metoda de mai jos fara view 
  #foloseste ca view myvideo1.html.erb care e folosit si la tayv2
  #deci daca mai vreau si pt alt curs pun: before_action :set_user2, only: %i[myvideo2]
  #si fac metoda et_user3 de exemplu iar in view unde apas 'Vezi video' pun:
  #<%= link_to "Vezi video", myvideo2_path(id: video.id, link: video.link), class: "btn btn-primary" %> 
  def myvideo2 #pt nutritie3
    @myvideo1 = Video.find(params[:id])
    @myvideo = Video.find(params[:id])[:link]
    render 'myvideo1'
  end
  def myvideo3 #pt an1
    @myvideo1 = Video.find(params[:id])
    @myvideo = Video.find(params[:id])[:link]
    render 'myvideo1'
  end
  def myvideo4 #pt tayt12
    @myvideo1 = Video.find(params[:id])
    @myvideo = Video.find(params[:id])[:link]
    render 'myvideo1'
  end
  def myvideo44 #pt tayt12
    @myvideo1 = Video.find(params[:id])
    @myvideo = Video.find(params[:id])[:link]
    render 'myvideo1'
  end
  def myvideo444 #pt tayt12  video introductive la liber pt cei care au achitat doar tabara
    @myvideo1 = Video.find(params[:id])
    @myvideo = Video.find(params[:id])[:link]
    render 'myvideo1'
  end
  def myvideo6 #pt nutritie2
    @myvideo1 = Video.find(params[:id])
    @myvideo = Video.find(params[:id])[:link]
    render 'myvideo1'
  end
  def myvideo67 #pt nutritie2
    @myvideo1 = Video.find(params[:id])
    @myvideo = Video.find(params[:id])[:link]
    render 'myvideo1'
  end
  def myvideo7 #pt nutritie2
    @myvideo1 = Video.find(params[:id])
    @myvideo = Video.find(params[:id])[:link]
    render 'myvideo1'
  end
  def myvideo8 #pt nutritie1
    @myvideo1 = Video.find(params[:id])
    @myvideo = Video.find(params[:id])[:link]
    render 'myvideo1'
  end

  def myvideo9 #pt nutritie1
    @myvideo1 = Video.find(params[:id])
    @myvideo = Video.find(params[:id])[:link]
    render 'myvideo1'
  end
  def myvideo10 #pt an2
    @myvideo1 = Video.find(params[:id])
    @myvideo = Video.find(params[:id])[:link]
    render 'myvideo1'
  end
  def myvideo11 #pt jivaka
    @myvideo1 = Video.find(params[:id])
    @myvideo = Video.find(params[:id])[:link]
    render 'myvideo1'
  end
  def myvideo12 #pt nutritie4
    @myvideo1 = Video.find(params[:id])
    @myvideo = Video.find(params[:id])[:link]
    render 'myvideo1'
  end
  def myvideo122 #pt nutritie4 resurse
    @myvideo1 = Video.find(params[:id])
    @myvideo = Video.find(params[:id])[:link]
    render 'myvideo1'
  end
  def myvideo13 #pt vajikarana1
    @myvideo1 = Video.find(params[:id])
    @myvideo = Video.find(params[:id])[:link]
    render 'myvideo1'
  end
  def myvideo133 #pt vajikarana1 resurse
    @myvideo1 = Video.find(params[:id])
    @myvideo = Video.find(params[:id])[:link]
    render 'myvideo1'
  end
  def myvideo14 #pt tayv24
    @myvideo1 = Video.find(params[:id])
    @myvideo = Video.find(params[:id])[:link]
    render 'myvideo1'
  end
  def myvideo144 #pt tayv24 resurse
    @myvideo1 = Video.find(params[:id])
    @myvideo = Video.find(params[:id])[:link]
    render 'myvideo1'
  end
  def myvideo15 #pt sesiune vara
    @myvideo1 = Video.find(params[:id])
    @myvideo = Video.find(params[:id])[:link]
    render 'myvideo1'
  end
  def myvideo16 #pt an2 24-25
    @myvideo1 = Video.find(params[:id])
    @myvideo = Video.find(params[:id])[:link]
    render 'myvideo1'
  end
  def myvideo17 #pt an2 24-25
    @myvideo1 = Video.find(params[:id])
    @myvideo = Video.find(params[:id])[:link]
    render 'myvideo1'
  end
  def myvideo18 #pt an2 24-25
    @myvideo1 = Video.find(params[:id])
    @myvideo = Video.find(params[:id])[:link]
    render 'myvideo1'
  end
  def myvideo19 #pt rasayana
    @myvideo1 = Video.find(params[:id])
    @myvideo = Video.find(params[:id])[:link]
    render 'myvideo1'
  end
  def myvideo20 #pt an1 24-25
    @myvideo1 = Video.find(params[:id])
    @myvideo = Video.find(params[:id])[:link]
    render 'myvideo1'
  end
  def myvideo21 #pt an1 24-25
    @myvideo1 = Video.find(params[:id])
    @myvideo = Video.find(params[:id])[:link]
    render 'myvideo1'
  end
  def myvideo22 #pt an1 24-25
    @myvideo1 = Video.find(params[:id])
    @myvideo = Video.find(params[:id])[:link]
    render 'myvideo1'
  end
  def myvideo23 #pt tayt24
    @myvideo1 = Video.find(params[:id])
    @myvideo = Video.find(params[:id])[:link]
    render 'myvideo1'
  end
  ################################################################
  
  
  ## GET /videos/1 or /videos/1.json
  def show
  end

  # GET /videos/new
  def new
    @video = Video.new
  end

  # GET /videos/1/edit
  def edit
  end

  # POST /videos or /videos.json
  def create
    @video = Video.new(video_params)

    respond_to do |format|
      if @video.save
        format.html { redirect_to video_url(@video), notice: "Video was successfully created." }
        format.json { render :show, status: :created, location: @video }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /videos/1 or /videos/1.json
  def update
    respond_to do |format|
      if @video.update(video_params)
        format.html { redirect_to video_url(@video), notice: "Video was successfully updated." }
        format.json { render :show, status: :ok, location: @video }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1 or /videos/1.json
  def destroy
    @video.destroy

    respond_to do |format|
      format.html { redirect_to videos_url, notice: "Video was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = Video.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def video_params
      params.require(:video).permit(:nume, :descriere, :sursa, :link, :tip, :ordine, :luna, :cod, :linkpdf, :link_debian)
    end

    def set_user
      # Verifica daca userul este logat
      if current_user && current_user.role == 1
       
        else
          # Utilizatorul nu are acces la resursa
         
          redirect_to root_path
      end
    
    end
    def set_user1
      # Verifică dacă userul este logat
      unless user_signed_in?
        flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
        redirect_to new_user_session_path # Presupunând că aceasta este calea către login
        return
      end
    
      # Dacă userul are rolul 1, îi dăm acces direct
      return true if current_user.role == 1
    
      tayv2_course = Listacursuri.find_by(nume: 'tayv2')
    
      if tayv2_course.nil?
        flash[:alert] = "Cursul nu a fost găsit."
        redirect_to root_path
        return
      end
    
      # Găsim înregistrarea din tabelul Cursuri pentru utilizatorul și cursul curent
      user_course = Cursuri.find_by(user_id: current_user.id, listacursuri_id: tayv2_course.id)
    
      unless user_course
        flash[:alert] = "Nu aveți acces la acest curs."
        redirect_to servicii_path
        return
      end
    
      # Verificăm dacă datasfarsit este nil sau dacă data curentă este mai mică sau egală cu datasfarsit
      if user_course.datasfarsit && user_course.datasfarsit < Date.today
        flash[:alert] = "Accesul la acest curs a expirat."
        redirect_to root_path
      end
    end
    def set_user2
          unless user_signed_in?
            flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
            redirect_to new_user_session_path
            return false
          end
        
          if current_user.role == 1
            return true
          elsif current_user.role == 0
            date_condition = Date.today <= Date.new(2024, 1, 31)
            has_access = date_condition && ComenziProd.joins(:prod)
                                                      .where(user_id: current_user.id, 
                                                              prods: { cod: ["cod11", "cod12", "cod13"] }, 
                                                              validat: "Finalizata")
                                                      .where("to_char(datainceput, 'YYYY') = ?", "2023")
                                                      .exists?
        
            has_recent_access = ComenziProd.where(user_id: current_user.id, validat: "Finalizata")
                                          .where("datainceput > ?", Date.new(2024, 1, 1))
                                          .where(prod_id: Prod.where(cod: ["cod12", "cod38"]).select(:id))
                                          .order(datainceput: :desc)
                                          .first
                                          .yield_self { |comanda_recenta| comanda_recenta && (Date.today <= comanda_recenta.datainceput + comanda_recenta.prod.valabilitatezile.days) }
        
            unless has_access || has_recent_access
              flash[:alert] = "Nu aveți acces la acest curs."
              redirect_to nutritie3_path # Schimbați cu calea dorită
              return false
            end
          else
            flash[:alert] = "Nu aveți permisiuni suficiente pentru a accesa acest curs."
            redirect_to nutritie3_path # Schimbați cu calea dorită
            return false
          end
        
          true
    end
    
    
    
    
    
    def set_user3




      # Verifică dacă userul este logat
      unless user_signed_in?
        flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest videoclip."
        redirect_to new_user_session_path # Presupunând că aceasta este calea către login
        return
      end
    
      # Dacă userul are rolul 1, îi dăm acces direct
      return true if current_user.role == 1
      
      # Află video-ul pe care user-ul dorește să-l acceseze
      video_dorit = Video.find(params[:id])
      
      # Verificăm dacă user-ul curent a plătit pentru video-ul dorit
      if ComenziProd.joins(:prod)
        .where(user_id: current_user.id, prods: { cod: video_dorit.cod }, validat: "Finalizata")
        .where("datasfarsit IS NULL OR datasfarsit >= ?", Date.current)
        .exists?
      
      return true
      end

      
      # Dacă nu se potrivește niciuna dintre condițiile de mai sus
      flash[:alert] = "Nu aveți acces la acest videoclip."
      redirect_to cursayurveda2425_path
    end
    

    def set_user4
      puts("da0")
      # Verifică dacă userul este logat
      unless user_signed_in?
        flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
        redirect_to new_user_session_path
        return
      end
    
      # Dacă userul are rolul 1, îi dăm acces direct
      return true if current_user.role == 1
    puts("da1")
      # Verifică dacă userul are cod12
      condition1 = ComenziProd.joins(:prod)
            .where(user_id: current_user.id, prods: { cod: ["cod40", "cod41", "cod42", "cod43", "cod44", "cod45"] }, validat: "Finalizata")
            .exists?

      condition2 = ComenziProd.joins(:prod)
            .where(user_id: current_user.id, prods: { cod: "cod54" }, validat: "Finalizata")
            .where("datasfarsit >= ?", Date.current)
            .exists?


      unless condition1 && condition2
        puts("nu se verifica conditiile")
        puts("condition1= #{condition1}") #true
        puts("condition2= #{condition2}") #false
      redirect_to root_path and return
      end

      puts("da2")
    
      
    
      tayt12_course = Listacursuri.find_by(nume: 'tayt12')
    
      if tayt12_course.nil?
        flash[:alert] = "Cursul nu a fost găsit."
        puts("da3")
        redirect_to root_path
        puts("da4")
        return
      end
      puts("da5")
      # Găsim înregistrarea din tabelul Cursuri pentru utilizatorul și cursul curent
      user_course = Cursuri.find_by(user_id: current_user.id, listacursuri_id: tayt12_course.id)
      puts("da6")
      unless user_course
        puts("da7")
        flash[:alert] = "Nu aveți acces la acest curs."
        redirect_to servicii_path
        return
      end
      puts("da8")

      
      
      
      puts("da10")
    end
    def set_user44
      puts("da00")
      # Verifică dacă userul este logat
      unless user_signed_in?
        flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
        redirect_to new_user_session_path
        return
      end
    
      # Dacă userul are rolul 1, îi dăm acces direct
      return true if current_user.role == 1
    puts("da11")
      # Verifică dacă userul are cod12
      condition1 = ComenziProd.joins(:prod)
            .where(user_id: current_user.id, prods: { cod: ["cod40", "cod41", "cod42", "cod43", "cod44", "cod45"] }, validat: "Finalizata")
            .exists?

            condition2 = ComenziProd.joins(:prod)
            .where(user_id: current_user.id, prods: { cod: "cod64" }, validat: "Finalizata")
            .where("datasfarsit >= ?", Date.current)
            .exists?

      unless condition1 && condition2
      redirect_to root_path and return
      end

      puts("da22")
    
      
    
      tayt12_course = Listacursuri.find_by(nume: 'tayt12')
    
      if tayt12_course.nil?
        flash[:alert] = "Cursul nu a fost găsit."
        redirect_to root_path
        return
      end
    
      # Găsim înregistrarea din tabelul Cursuri pentru utilizatorul și cursul curent
      user_course = Cursuri.find_by(user_id: current_user.id, listacursuri_id: tayt12_course.id)
    
      unless user_course
        puts("da23")
        flash[:alert] = "Nu aveți acces la acest curs."
        redirect_to servicii_path
        return
      end
    
     
    end

    def set_user444
      puts("da0")
      # Verifică dacă userul este logat
      unless user_signed_in?
        flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
        redirect_to new_user_session_path
        return
      end
    
      # Dacă userul are rolul 1, îi dăm acces direct
      return true if current_user.role == 1
    puts("da1")
      # Verifică dacă userul are cod12
      condition1 = ComenziProd.joins(:prod)
            .where(user_id: current_user.id, prods: { cod: ["cod40", "cod41", "cod42", "cod43", "cod44", "cod45"] }, validat: "Finalizata")
            .exists?

      


      unless condition1 
        puts("nu se verifica conditiile")
        puts("condition1= #{condition1}") #true
        #puts("condition2= #{condition2}") #false
      redirect_to root_path and return
      end

      puts("da2")
    
      
    
      tayt12_course = Listacursuri.find_by(nume: 'tayt12')
    
      if tayt12_course.nil?
        flash[:alert] = "Cursul nu a fost găsit."
        puts("da3")
        redirect_to root_path
        puts("da4")
        return
      end
      puts("da5")
      # Găsim înregistrarea din tabelul Cursuri pentru utilizatorul și cursul curent
      user_course = Cursuri.find_by(user_id: current_user.id, listacursuri_id: tayt12_course.id)
      puts("da6")
      unless user_course
        puts("da7")
        flash[:alert] = "Nu aveți acces la acest curs."
        redirect_to servicii_path
        return
      end
      puts("da8")

      
      
      
      puts("da10")
    end


    def set_user6
      unless user_signed_in?
        flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
        redirect_to new_user_session_path
        return
      end
    
      has_module_1 = UserModulecursuri.exists?(user_id: current_user.id, 
                                               modulecursuri_id: 3, 
                                               validat: "Finalizata")
    
   
    
      unless has_module_1  || current_user.role == 1
        flash[:alert] = "Nu aveți acces la acest curs."
        redirect_to root_path # sau o altă cale relevantă
      end
    end

    def set_user67
     

      unless user_signed_in?
        flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
        redirect_to new_user_session_path
        return
      end


  


    puts("sal0")
      comanda = ComenziProd.where(user_id: current_user.id, validat: "Finalizata")
          .where(prod_id: Prod.where(cod: ['cod72', 'cod74']).select(:id))
          .order(datasfarsit: :desc)
          .first
      puts("sal1")
      @condition1 = comanda && comanda.datasfarsit >= Date.today
      puts("sal2")
      Rails.logger.info "Condition1 este: #{@condition1}, User Role: #{current_user.role}"
      unless @condition1 || current_user.role == 1
      redirect_to root_path
      flash[:alert] = "Nu aveți acces la acest curs."
      end

    end
    
  
    
    def set_user7
      unless user_signed_in?
        flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
        redirect_to new_user_session_path # Presupunând că aceasta este calea către login
        return
      end
    
      if current_user.role == 1
        return true
      end
      if ComenziProd.joins(:prod).where(user_id: current_user.id, prods: { cod: ["cod11", "cod12", "cod13","cod38"] }, validat: "Finalizata").exists?
      return true
      else
        redirect_to nutritie3_path # Schimbați cu calea dorită
        return false
      end
    end  

    def set_user8 # nutritie1 p1 si p2
      unless user_signed_in?
        flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
        redirect_to new_user_session_path
        return
      end
    
      has_module_1 = UserModulecursuri.exists?(user_id: current_user.id, 
                                               modulecursuri_id: 1, 
                                               validat: "Finalizata")
    
      has_module_2 = UserModulecursuri.exists?(user_id: current_user.id, 
                                               modulecursuri_id: 2, 
                                               validat: "Finalizata")
    
      unless (has_module_1 && has_module_2) || current_user.role == 1
        flash[:alert] = "Nu aveți acces la acest curs."
        redirect_to root_path # sau o altă cale relevantă
      end
    end
    
    def set_user9 # nutritie1 video cursuri
      unless user_signed_in?
        flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
        redirect_to new_user_session_path
        return
      end
    
     

      @condition1 = if current_user
        comanda = ComenziProd.where(user_id: current_user.id, validat: "Finalizata")
                            .where(prod_id: Prod.where(cod: ['cod73', 'cod75']).select(:id))
                            .order(datasfarsit: :desc)
                            .first
        comanda && comanda.datasfarsit && comanda.datasfarsit >= Date.today
      else
        false
      end




     




      unless @condition1 || current_user.role == 1
      flash[:alert] = "Nu aveți acces la acest curs."
      redirect_to root_path # sau o altă cale relevantă
      end

    end
    
    def set_user10
      # Verifică dacă userul este logat
      unless user_signed_in?
        flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest videoclip."
        redirect_to new_user_session_path # Presupunând că aceasta este calea către login
        return
      end
    
      # Dacă userul are rolul 1, îi dăm acces direct
      return true if current_user.role == 1
      
      # Află video-ul pe care user-ul dorește să-l acceseze
      video_dorit = Video.find(params[:id])
      
      # Verificăm dacă user-ul curent a plătit pentru video-ul dorit
      if ComenziProd.joins(:prod)
        .where(user_id: current_user.id, prods: { cod: video_dorit.cod }, validat: "Finalizata")
        .where("datasfarsit IS NULL OR datasfarsit >= ?", Date.current)
        .exists?
      
      return true
      end

      
      # Dacă nu se potrivește niciuna dintre condițiile de mai sus
      flash[:alert] = "Nu aveți acces la acest videoclip."
      redirect_to servicii_path
    end

    def set_user11
       # Verifică dacă userul este logat
       unless user_signed_in?
        flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest videoclip."
        redirect_to new_user_session_path # Presupunând că aceasta este calea către login
        return
      end
    
      # Dacă userul are rolul 1, îi dăm acces direct
      return true if current_user.role == 1
      
      # Află video-ul pe care user-ul dorește să-l acceseze
      video_dorit = Video.find(params[:id])
       # Verificăm dacă user-ul curent a plătit pentru video-ul dorit
       if ComenziProd.joins(:prod)
        .where(user_id: current_user.id, prods: { cod: video_dorit.cod }, validat: "Finalizata")
        .where("datasfarsit IS NULL OR datasfarsit >= ?", Date.current)
        .exists?
      
      return true
      end

      
      # Dacă nu se potrivește niciuna dintre condițiile de mai sus
      flash[:alert] = "Nu aveți acces la acest videoclip."
      #redirect_to traditia_ayurvedica_path
      redirect_to root_path

    end  

    def set_user12
      puts("aaaaaaaaa nutritie4")
      unless user_signed_in?
        flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
        redirect_to new_user_session_path
        return false
      end
    
      if current_user.role == 1
        return true
      elsif current_user.role == 0
        data_prag = Date.new(2024, 5, 19)
    
        # Obține codurile produselor cumpărate și datele de început și sfârșit
        purchased_prods = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
                                     .joins(:prod)
                                     .where(prods: { curslegatura: 'nutritie4' })
                                     .pluck('prods.cod', 'datainceput', 'datasfarsit')
    
        purchased_prods1 = ComenziProd1.where(user_id: current_user.id, validat: 'Finalizata')
                                       .joins(:prod)
                                       .where(prods: { curslegatura: 'nutritie4' })
                                       .pluck('prods.cod', 'datainceput', 'datasfarsit')
    
        # Dacă nu există produse cumpărate, inițializează array-ul cu produse cumpărate ca gol
        purchased_prods ||= []
        purchased_prods1 ||= []
    
        # Combină listele de produse
        all_purchased_prods = purchased_prods + purchased_prods1
    
        puts("Produse cumpărate cu date: #{all_purchased_prods}")
    
        # Filtrare produse valabile
        valid_prods = all_purchased_prods.select do |_, datainceput, _|
          if datainceput && datainceput < data_prag
            data_prag + 90.days >= Date.today
          else
            datainceput && datainceput + 90.days >= Date.today
          end
        end.map(&:first)
    
        puts("Produse valabile: #{valid_prods}")
    
        has_access = valid_prods.include?('cod86') || valid_prods.include?('cod88')
    
        puts("has_access este: #{has_access}")
    
        unless has_access
          flash[:alert] = "Nu aveți acces la acest curs."
          redirect_to nutritie4_index_path # Schimbați cu calea dorită
          return false
        end
      else
        flash[:alert] = "Nu aveți permisiuni suficiente pentru a accesa acest curs."
        redirect_to nutritie4_index_path # Schimbați cu calea dorită
        return false
      end
    
      true
    end
    
    
    def set_user122 # este pt aspecte organizatorice nutritie4
      unless user_signed_in?
        flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
        redirect_to new_user_session_path # Presupunând că aceasta este calea către login
        return
      end
    
      if current_user.role == 1
        return true
      end
      if ComenziProd.joins(:prod).where(user_id: current_user.id, prods: { cod: ["cod85", "cod86", "cod87","cod88","cod89"] }, validat: "Finalizata").exists?
      return true
      else
        redirect_to nutritie3_path # Schimbați cu calea dorită
        return false
      end
    end  
def set_user13
  puts("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
  unless user_signed_in?
    flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
    redirect_to new_user_session_path
    return false
  end

  if current_user.role == 1
    return true
  elsif current_user.role == 0
    data_prag = Date.new(2024, 2, 25)

    # Obține codurile produselor cumpărate și datele de început și sfârșit
    purchased_prods = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
                                 .joins(:prod)
                                 .where(prods: { curslegatura: 'vajikarana1' })
                                 .pluck('prods.cod', 'datainceput', 'datasfarsit')

    purchased_prods1 = ComenziProd1.where(user_id: current_user.id, validat: 'Finalizata')
                                   .joins(:prod)
                                   .where(prods: { curslegatura: 'vajikarana1' })
                                   .pluck('prods.cod', 'datainceput', 'datasfarsit')

    # Dacă nu există produse cumpărate, inițializează array-ul cu produse cumpărate ca gol
    purchased_prods ||= []
    purchased_prods1 ||= []

    # Combină listele de produse
    all_purchased_prods = purchased_prods + purchased_prods1

    puts("Produse cumpărate cu date: #{all_purchased_prods}")

    # Filtrare produse valabile
    #valid_prods = all_purchased_prods.select { |_, datainceput, _| datainceput + 90.days >= Date.today }.map(&:first)
    valid_prods = purchased_prods.select { |_, _, datasfarsit| datasfarsit && datasfarsit >= Date.today }.map(&:first)

    puts("Produse valabile: #{valid_prods}")

    has_access = valid_prods.include?('cod109') || valid_prods.include?('cod110')

    puts("has_access este: #{has_access}")

    unless has_access
      flash[:alert] = "Nu aveți acces la acest curs."
      redirect_to nutritie4_index_path # Schimbați cu calea dorită
      return false
    end
  else
    flash[:alert] = "Nu aveți permisiuni suficiente pentru a accesa acest curs."
    redirect_to nutritie4_index_path # Schimbați cu calea dorită
    return false
  end

  true
end


def set_user133
  
  unless user_signed_in?
    flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
    redirect_to new_user_session_path # Presupunând că aceasta este calea către login
    return
  end

  if current_user.role == 1
    return true
  end
  if ComenziProd.joins(:prod).where(user_id: current_user.id, prods: { cod: ["cod110", "cod108", "cod109"] }, validat: "Finalizata").exists?
  return true
  else
    redirect_to vajikarana_modul1_path # Schimbați cu calea dorită
    return false
  end
end  



def set_user14
  puts("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
  unless user_signed_in?
    flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
    redirect_to new_user_session_path
    return false
  end

  if current_user.role == 1
    return true
  elsif current_user.role == 0
    data_prag = Date.new(2024, 7, 16)

    # Obține codurile produselor cumpărate și datele de început și sfârșit
    purchased_prods = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
                                 .joins(:prod)
                                 .where(prods: { curslegatura: 'tayv24' })
                                 .pluck('prods.cod', 'datainceput', 'datasfarsit')

    purchased_prods1 = ComenziProd1.where(user_id: current_user.id, validat: 'Finalizata')
                                   .joins(:prod)
                                   .where(prods: { curslegatura: 'tayv24' })
                                   .pluck('prods.cod', 'datainceput', 'datasfarsit')

    # Dacă nu există produse cumpărate, inițializează array-ul cu produse cumpărate ca gol
    purchased_prods ||= []
    purchased_prods1 ||= []

    # Combină listele de produse
    all_purchased_prods = purchased_prods + purchased_prods1

    puts("Produse cumpărate cu date: #{all_purchased_prods}")

    # Filtrare produse valabile
    valid_prods = all_purchased_prods.select { |_, datainceput, _| datainceput + 90.days >= Date.today }.map(&:first)

    puts("Produse valabile: #{valid_prods}")

    has_access = valid_prods.include?('cod176') || valid_prods.include?('cod177') || valid_prods.include?('cod178')

    puts("has_access este: #{has_access}")

    unless has_access
      flash[:alert] = "Nu aveți acces la acest curs."
      redirect_to root_path # Schimbați cu calea dorită
      return false
    end
  else
    flash[:alert] = "Nu aveți permisiuni suficiente pentru a accesa acest curs."
    redirect_to root_path # Schimbați cu calea dorită
    return false
  end

  true
end


def set_user144
  puts("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
  
  unless user_signed_in?
    flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
    redirect_to new_user_session_path
    return false
  end

  # Listele de utilizatori
  an1 = ["aura.tiparu@gmail.com", "liveplaylovebetter@protonmail.com", "elena.riba7@yahoo.com", "v_ionela@yahoo.com"]
  an2 = ["cristinastanescu995@gmail.com", "delia_orita@yahoo.co.uk", "emilia777emi@gmail.com", "marianacuceu@yahoo.com",
         "crisgavrilescu707@gmail.com", "v_ionela@yahoo.com"]
  an3 = ["ovidiu_popovici_vlad@yahoo.com", "ce.hermkens@gmail.com", "szabo.doina@yahoo.com", "crina_dora@yahoo.com"]
  an4 = ["sorincsv@yahoo.com", "fhun8@hotmail.com", "roalexis71@gmail.com", "florynn85@yahoo.com", "arthadora2012@gmail.com",
         "lidiaistodorescu@yahoo.com"]

  # Videoclipuri asociate
  video_links = {
    an1: 'S4C0zZW8Vvw',
    an2: 'ClYxngJ_Vm0',
    an3: 'ubItratex9I',
    an4: 'jHx5c6lOzVM'
  }

  # Golește array-urile după 15 decembrie 2024
  if Date.today > Date.new(2024, 12, 15)
    an1 = []
    an2 = []
    an3 = []
    an4 = []
  end       

  # Normalizează emailurile utilizatorului și din liste
  user_email = current_user.email.strip.downcase
  an1.map!(&:strip).map!(&:downcase)
  an2.map!(&:strip).map!(&:downcase)
  an3.map!(&:strip).map!(&:downcase)
  an4.map!(&:strip).map!(&:downcase)

  # Verifică rolul și permisiunile utilizatorului
  if current_user.role == 1
    # Adminul are acces complet
    return true
  elsif current_user.role == 0
    # Verifică dacă utilizatorul face parte din vreun grup
    if an1.include?(user_email) || an2.include?(user_email) || an3.include?(user_email) || an4.include?(user_email)
      # Debugging pentru email și grupuri
      puts "Email utilizator: #{user_email}"
      puts "Este în an1? #{an1.include?(user_email)}"
      puts "Este în an2? #{an2.include?(user_email)}"
      puts "Este în an3? #{an3.include?(user_email)}"
      puts "Este în an4? #{an4.include?(user_email)}"

      # Permite accesul dacă este într-un grup
      return true
    else
      # Mesaj de eroare pentru utilizatorii neautorizați
      flash[:alert] = "Nu aveți permisiunea de a accesa acest curs."
      redirect_to root_path
      return false
    end
  else
    # Pentru orice alt caz, accesul este refuzat
    flash[:alert] = "Nu aveți permisiunea de a accesa acest curs."
    redirect_to root_path
    return false
  end
end


def set_user15
  puts("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
  unless user_signed_in?
    flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
    redirect_to new_user_session_path
    return false
  end

  if current_user.role == 1
    return true
  elsif current_user.role == 0
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

    @has_access = @valid_prods.any?
    puts("verificare daca are produse valabile: #{@has_access}")
    
    if @has_access
      return true
    else
      redirect_to root_path
      return false
    end  
  end
end



def set_user16 #merge bine ia in considerare si datasfarsit
  puts("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")

  # Verificare dacă utilizatorul este autentificat
  unless user_signed_in?
    flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
    redirect_to new_user_session_path
    return false
  end

  # Verificare rolul utilizatorului
  if current_user.role == 1
    # Admin, are acces la toate videoclipurile
    return true
  elsif current_user.role == 0
    # Utilizator normal, trebuie să verificăm dacă a cumpărat produse valide
    purchased_prods = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
                                 .joins(:prod)
                                 .where(prods: { curslegatura: 'an2_2425', status: 'activ' })
                                 .pluck('prods.cod', 'datainceput', 'datasfarsit')

    purchased_prods1 = ComenziProd1.where(user_id: current_user.id, validat: 'Finalizata')
                                   .joins(:prod)
                                   .where(prods: { curslegatura: 'an2_2425', status: 'activ' })
                                   .pluck('prods.cod', 'datainceput', 'datasfarsit')

    # Inițializare listă produse, dacă nu există
    purchased_prods ||= []
    purchased_prods1 ||= []

    # Combinare produse cumpărate
    all_purchased_prods = purchased_prods + purchased_prods1
    puts("Produse cumpărate cu date: #{all_purchased_prods}")

    # Produsele valabile (datasfarsit >= azi)
    @valid_prods = all_purchased_prods.select { |_, _, datasfarsit| 
      datasfarsit.present? && datasfarsit >= Date.today 
    }.map(&:first)

    # Produsele expirate (datasfarsit < azi)
    @expired_prods = all_purchased_prods.select { |_, _, datasfarsit| 
      datasfarsit.present? && datasfarsit < Date.today 
    }.map(&:first)

    puts("Produse valabile: #{@valid_prods}")
    puts("Produse expirate: #{@expired_prods}")

    # Verificare dacă utilizatorul are produse valide (neexpirate)
    @has_access = @valid_prods.any?
    puts("Verificare dacă are produse valabile: #{@has_access}")

    # Dacă utilizatorul nu are produse valabile, redirecționează la pagina principală
    unless @has_access
      flash[:alert] = "Nu aveți acces la acest curs. Toate produsele cumpărate au expirat."
      redirect_to root_path
      return false
    end

    # Verificare suplimentară: identifică codul produsului accesat folosind id-ul video-ului sau link-ul
    video = Video.find_by(id: params[:id]) # Caută video-ul folosind ID-ul din params
    produs_cod_accesat = video&.cod # Găsește codul produsului asociat cu video-ul, presupunând că video-ul are un atribut `cod`

    puts("Produs accesat (codul): #{produs_cod_accesat}")

    # Verificare dacă produsul accesat este în lista produselor expirate
    if @expired_prods.include?(produs_cod_accesat) && !@valid_prods.include?(produs_cod_accesat)
      flash[:alert] = "Produsul pe care încercați să îl accesați este expirat. Redirecționare către pagina principală."
      redirect_to root_path
      return false
    end

    # Dacă produsul accesat nu este expirat sau este valabil, permite accesul
    return true
  else
    # În caz că utilizatorul are alt rol (dacă există alte cazuri speciale)
    flash[:alert] = "Acces interzis."
    redirect_to root_path
    return false
  end
end



def set_user17 #merge bine ia in considerare si datasfarsit
  puts("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
  
  # Verificare dacă utilizatorul este autentificat
  unless user_signed_in?
    flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
    redirect_to new_user_session_path
    return false
  end

  # Verificare rolul utilizatorului
  if current_user.role == 1
    # Admin, are acces
    return true
  elsif current_user.role == 0
    # Utilizator normal, trebuie să verificăm dacă a cumpărat produse valide
    purchased_prods = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
                                 .joins(:prod)
                                 .where(prods: { curslegatura: 'an3_2425', status: 'activ' })
                                 .pluck('prods.cod', 'datainceput', 'datasfarsit')

    purchased_prods1 = ComenziProd1.where(user_id: current_user.id, validat: 'Finalizata')
                                   .joins(:prod)
                                   .where(prods: { curslegatura: 'an3_2425', status: 'activ' })
                                   .pluck('prods.cod', 'datainceput', 'datasfarsit')

    # Inițializare listă produse, dacă nu există
    purchased_prods ||= []
    purchased_prods1 ||= []

    # Combinare produse cumpărate
    all_purchased_prods = purchased_prods + purchased_prods1
    puts("Produse cumpărate cu date: #{all_purchased_prods}")

    # Produsele valabile (în ultimele 60 de zile)
    @valid_prods = all_purchased_prods.select { |_, datainceput, datasfarsit| 
      datasfarsit && datasfarsit >= Date.today 
    }.map(&:first)

    # Produsele expirate (nu au acces)
    @expired_prods = all_purchased_prods.select { |_, _, datasfarsit| 
      datasfarsit && datasfarsit < Date.today 
    }.map(&:first)

    puts("Produse valabile: #{@valid_prods}")
    puts("Produse expirate: #{@expired_prods}")

    # Verificare dacă utilizatorul are produse valide
    @has_access = @valid_prods.any?
    puts("verificare daca are produse valabile: #{@has_access}")
    
    if @has_access
      puts("am accessssssss")
      # Utilizatorul are acces
      return true
    else
      puts(" NU am accessssssss")
      # Utilizatorul nu are produse valabile, redirect la pagina principală
      flash[:alert] = "Nu aveți acces la acest curs. Produsele cumpărate au expirat."
      redirect_to root_path
      return false
    end  
  else
    # În caz că utilizatorul are alt rol (dacă există alte cazuri speciale)
    flash[:alert] = "Acces interzis."
    redirect_to root_path
    return false
  end
end


def set_user18 #merge bine ia in considerare si datasfarsit
  puts("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
  
  # Verificare dacă utilizatorul este autentificat
  unless user_signed_in?
    flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
    redirect_to new_user_session_path
    return false
  end

  # Verificare rolul utilizatorului
  if current_user.role == 1
    # Admin, are acces
    return true
  elsif current_user.role == 0
    # Utilizator normal, trebuie să verificăm dacă a cumpărat produse valide
    purchased_prods = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
                                 .joins(:prod)
                                 .where(prods: { curslegatura: 'an4_2425', status: 'activ' })
                                 .pluck('prods.cod', 'datainceput', 'datasfarsit')

    purchased_prods1 = ComenziProd1.where(user_id: current_user.id, validat: 'Finalizata')
                                   .joins(:prod)
                                   .where(prods: { curslegatura: 'an4_2425', status: 'activ' })
                                   .pluck('prods.cod', 'datainceput', 'datasfarsit')

    # Inițializare listă produse, dacă nu există
    purchased_prods ||= []
    purchased_prods1 ||= []

    # Combinare produse cumpărate
    all_purchased_prods = purchased_prods + purchased_prods1
    puts("Produse cumpărate cu date: #{all_purchased_prods}")

    # Produsele valabile (în ultimele 60 de zile)
    @valid_prods = all_purchased_prods.select { |_, datainceput, datasfarsit| 
      datasfarsit && datasfarsit >= Date.today 
    }.map(&:first)

    # Produsele expirate (nu au acces)
    @expired_prods = all_purchased_prods.select { |_, _, datasfarsit| 
      datasfarsit && datasfarsit < Date.today 
    }.map(&:first)

    puts("Produse valabile: #{@valid_prods}")
    puts("Produse expirate: #{@expired_prods}")

    # Verificare dacă utilizatorul are produse valide
    @has_access = @valid_prods.any?
    puts("verificare daca are produse valabile: #{@has_access}")
    
    if @has_access
      puts("am accessssssss")
      # Utilizatorul are acces
      return true
    else
      puts(" NU am accessssssss")
      # Utilizatorul nu are produse valabile, redirect la pagina principală
      flash[:alert] = "Nu aveți acces la acest curs. Produsele cumpărate au expirat."
      redirect_to root_path
      return false
    end  
  else
    # În caz că utilizatorul are alt rol (dacă există alte cazuri speciale)
    flash[:alert] = "Acces interzis."
    redirect_to root_path
    return false
  end
end
def set_user19
  ## Verificare dacă utilizatorul este autentificat
  unless user_signed_in?
    flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
    redirect_to new_user_session_path
    return false
  end

  # Verificare rolul utilizatorului
  if current_user.role == 1
    # Admin, are acces
    return true
  elsif current_user.role == 0
    # Utilizator normal, trebuie să verificăm dacă a cumpărat produse valide
    purchased_prods = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
                                 .joins(:prod)
                                 .where(prods: { curslegatura: 'rasayana1', status: 'activ' })
                                 .pluck('prods.cod', 'datainceput', 'datasfarsit')

    # Verifică dacă utilizatorul a cumpărat codurile 242 sau 243
    has_access = purchased_prods.any? { |cod, _, _| ['cod242', 'cod243'].include?(cod) }

    return true if has_access

    # Dacă nu are acces, afișăm mesaj și redirecționăm
    flash[:alert] = "Nu aveți acces la acest curs."
    redirect_to root_path 
    return false
  end
end

def set_user20 #merge bine ia in considerare si datasfarsit
  puts("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")

  # Verificare parametri disponibili pentru debugging
  puts("Parametrii disponibili: #{params.inspect}")

  # Verificare dacă utilizatorul este autentificat
  unless user_signed_in?
    flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
    redirect_to new_user_session_path
    return false
  end

  # Verificare rolul utilizatorului
  if current_user.role == 1
    # Admin, are acces
    return true
  elsif current_user.role == 0
    # Utilizator normal, trebuie să verificăm dacă a cumpărat produse valide
    purchased_prods = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
                                 .joins(:prod)
                                 .where(prods: { curslegatura: 'an1_2425', status: 'activ' })
                                 .pluck('prods.cod', 'datainceput', 'datasfarsit')

    purchased_prods1 = ComenziProd1.where(user_id: current_user.id, validat: 'Finalizata')
                                   .joins(:prod)
                                   .where(prods: { curslegatura: 'an1_2425', status: 'activ' })
                                   .pluck('prods.cod', 'datainceput', 'datasfarsit')

    # Inițializare listă produse, dacă nu există
    purchased_prods ||= []
    purchased_prods1 ||= []

    # Combinare produse cumpărate
    all_purchased_prods = purchased_prods + purchased_prods1
    puts("Produse cumpărate cu date: #{all_purchased_prods}")

    # Produsele valabile (datasfarsit >= azi)
    @valid_prods = all_purchased_prods.select { |_, _, datasfarsit| 
      datasfarsit.present? && datasfarsit >= Date.today 
    }.map(&:first)

    # Produsele expirate (datasfarsit < azi)
    @expired_prods = all_purchased_prods.select { |_, _, datasfarsit| 
      datasfarsit.present? && datasfarsit < Date.today 
    }.map(&:first)

    puts("Produse valabile: #{@valid_prods}")
    puts("Produse expirate: #{@expired_prods}")

    # Verificare dacă utilizatorul are produse valide (neexpirate)
    @has_access = @valid_prods.any?
    puts("Verificare dacă are produse valabile: #{@has_access}")

    # Dacă utilizatorul nu are produse valabile, redirecționează la pagina principală
    unless @has_access
      flash[:alert] = "Nu aveți acces la acest curs. Toate produsele cumpărate au expirat."
      redirect_to root_path
      return false
    end

    # Verificare suplimentară: identifică codul produsului accesat folosind id-ul video-ului sau link-ul
    video = Video.find_by(id: params[:id]) # Caută video-ul folosind ID-ul din params
    produs_cod_accesat = video&.cod # Găsește codul produsului asociat cu video-ul, presupunând că video-ul are un atribut `cod`
    
    puts("Produs accesat (codul): #{produs_cod_accesat}")

    # Verificare dacă produsul accesat este în lista produselor expirate
    if @expired_prods.include?(produs_cod_accesat) && !@valid_prods.include?(produs_cod_accesat)
      flash[:alert] = "Produsul pe care încercați să îl accesați este expirat. Redirecționare către pagina principală."
      redirect_to root_path
      return false
    end

    # Dacă produsul accesat nu este expirat sau este valabil, permite accesul
    return true
  else
    # În caz că utilizatorul are alt rol (dacă există alte cazuri speciale)
    flash[:alert] = "Acces interzis."
    redirect_to root_path
    return false
  end
end

def set_user21 #canal2
  # Verifică dacă utilizatorul este autentificat
  unless user_signed_in?
    puts("autentificareee")
    flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
    redirect_to new_user_session_path
    return false
  end

  lunile = ["septembrie", "octombrie", "noiembrie", "decembrie", "ianuarie", "februarie", "martie", "aprilie", "mai", "iunie", "iulie", "august"]

  # Verifică dacă utilizatorul are rolul 1 (rol special cu acces automat)
  unless current_user.role == 1
    # Găsește înregistrarea utilizatorului în tabelul Listacanal2 pe baza email-ului său
    inregistrare_user = Listacanal2.find_by(email: current_user.email)

    # Dacă nu există înregistrare și utilizatorul nu are rolul 1, redirecționează către root_path
    if inregistrare_user.nil?
      redirect_to root_path and return
    end

    # Verifică dacă utilizatorul nu a plătit (valoarea 'platit' este "nimic")
    if inregistrare_user.platit == "nimic"
      redirect_to root_path and return
    end

    # Obține luna curentă în format românesc și indexul acesteia
    luna_curenta_romana = luna_in_romana(Time.current.in_time_zone('Europe/Bucharest').strftime("%B"))
    index_luna_curenta = lunile.index(luna_curenta_romana)
    index_luna_platit = lunile.index(inregistrare_user.platit)

    # Calculăm indexul lunii anterioare
    index_luna_anterioara = (index_luna_curenta - 1) % lunile.length

    # Afișăm informații pentru debugging
    puts("luna_curenta_romana: #{luna_curenta_romana}")
    puts("index_luna_curenta: #{index_luna_curenta}")
    puts("index_luna_platit: #{index_luna_platit}")
    puts("index_luna_anterioara: #{index_luna_anterioara}")

    # Verificăm dacă luna 'platit' este anterioară lunii curente și lunii anterioare
    if index_luna_platit.nil? || index_luna_curenta.nil? || (index_luna_platit < index_luna_curenta && index_luna_platit < index_luna_anterioara)
      redirect_to root_path and return
    end
  end

  # Returnează true dacă toate verificările au trecut și utilizatorul are acces
  true
end

def set_user22 #canal3
  # Verifică dacă utilizatorul este autentificat
  unless user_signed_in?
    puts("autentificareee")
    flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
    redirect_to new_user_session_path
    return false
  end

  lunile = ["septembrie", "octombrie", "noiembrie", "decembrie", "ianuarie", "februarie", "martie", "aprilie", "mai", "iunie", "iulie", "august"]

  # Verifică dacă utilizatorul are rolul 1 (acces automat)
  unless current_user.role == 1
    # Găsește înregistrarea utilizatorului în tabelul Listacanal3 pe baza email-ului său
    inregistrare_user = Listacanal3.find_by(email: current_user.email)

    # Dacă nu există înregistrare și utilizatorul nu are rolul 1, redirecționează la root_path
    if inregistrare_user.nil?
      redirect_to root_path and return
    end

    # Verifică dacă utilizatorul nu a plătit (platit == "nimic")
    if inregistrare_user.platit == "nimic"
      redirect_to root_path and return
    end

    # Obține luna curentă în format românesc și indexul acesteia
    luna_curenta_romana = luna_in_romana(Time.current.in_time_zone('Europe/Bucharest').strftime("%B"))
    index_luna_curenta = lunile.index(luna_curenta_romana)
    index_luna_platit = lunile.index(inregistrare_user.platit)

    # Calculăm indexul lunii anterioare
    index_luna_anterioara = (index_luna_curenta - 1) % lunile.length

    # Afișează informații pentru debugging
    puts("luna_curenta_romana: #{luna_curenta_romana}")
    puts("index_luna_curenta: #{index_luna_curenta}")
    puts("index_luna_platit: #{index_luna_platit}")
    puts("index_luna_anterioara: #{index_luna_anterioara}")

    # Verifică dacă luna 'platit' este anterioară lunii curente și lunii anterioare
    if index_luna_platit.nil? || index_luna_curenta.nil? || (index_luna_platit < index_luna_curenta && index_luna_platit < index_luna_anterioara)
      redirect_to root_path and return
    end
  end

  # Returnează true dacă toate verificările au trecut și utilizatorul are acces
  true
end


def set_user23
  puts("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
  unless user_signed_in?
    flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
    redirect_to new_user_session_path
    return false
  end

  if current_user.role == 1
    return true
  elsif current_user.role == 0
    data_prag = Date.new(2024, 11, 19)

    # Obține codurile produselor cumpărate și datele de început și sfârșit
    purchased_prods = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
                                 .joins(:prod)
                                 .where(prods: { curslegatura: 'tayt24' })
                                 .pluck('prods.cod', 'datainceput', 'datasfarsit')

    purchased_prods1 = ComenziProd1.where(user_id: current_user.id, validat: 'Finalizata')
                                   .joins(:prod)
                                   .where(prods: { curslegatura: 'tayt24' })
                                   .pluck('prods.cod', 'datainceput', 'datasfarsit')

    # Dacă nu există produse cumpărate, inițializează array-ul cu produse cumpărate ca gol
    purchased_prods ||= []
    purchased_prods1 ||= []

    # Combină listele de produse
    all_purchased_prods = purchased_prods + purchased_prods1

    puts("Produse cumpărate cu date: #{all_purchased_prods}")

    # Filtrare produse valabile
    valid_prods = all_purchased_prods.select { |_, datainceput, _| datainceput + 90.days >= Date.today }.map(&:first)

    puts("Produse valabile: #{valid_prods}")

    has_access = valid_prods.include?('cod266') || valid_prods.include?('cod267') || valid_prods.include?('cod268')

    puts("has_access este: #{has_access}")

    unless has_access
      flash[:alert] = "Nu aveți acces la acest curs."
      redirect_to root_path # Schimbați cu calea dorită
      return false
    end
  else
    flash[:alert] = "Nu aveți permisiuni suficiente pentru a accesa acest curs."
    redirect_to root_path # Schimbați cu calea dorită
    return false
  end

  true
end




    def require_admin
      unless current_user && current_user.role == 1
        flash[:error] = "Only admins are allowed to access this page."
        redirect_to root_path
      end
    end
end
