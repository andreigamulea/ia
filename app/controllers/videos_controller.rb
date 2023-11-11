class VideosController < ApplicationController
  require 'date'

  before_action :set_video, only: %i[ show edit update destroy ]
  before_action :set_user, only: %i[ show edit update destroy]
  before_action :set_user1, only: %i[tayv2 myvideo1] #este pt tayv2
  before_action :set_user2, only: %i[myvideo2] #este pt nutritie3
  before_action :set_user7, only: %i[myvideo7] #este pt nutritie3 pt video de la Resurse si Aspecte organizatorice
  before_action :set_user6, only: %i[myvideo6] #este pt nutritie2
  before_action :set_user3, only: %i[myvideo3] #este pt an1
  before_action :set_user4, only: %i[myvideo4] #este pt tayt12
  before_action :set_user4, only: %i[myvideo5] #este pt tayt122 folosesc tot set_user4 pt ca e aceeasi plata si la tayt12 si la tayt122
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
  def myvideo5 #pt tayt122
    @myvideo1 = Video.find(params[:id])
    @myvideo = Video.find(params[:id])[:link]
    render 'myvideo1'
  end
  def myvideo6 #pt nutritie2
    @myvideo1 = Video.find(params[:id])
    @myvideo = Video.find(params[:id])[:link]
    render 'myvideo1'
  end
  def myvideo7 #pt nutritie2
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
      params.require(:video).permit(:nume, :descriere, :sursa, :link, :tip, :ordine, :luna, :cod, :linkpdf)
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
      # Verifică dacă userul este logat
      unless user_signed_in?
        flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
        redirect_to new_user_session_path # Presupunând că aceasta este calea către login
        return
      end
      puts("daaaaa1")
      # Dacă userul are rolul 1, îi dăm acces direct
      return true if current_user.role == 1
      puts("daaaaa2")
      # Verifică dacă userul are cod12
      return true if ComenziProd.joins(:prod).where(user_id: current_user.id, prods: { cod: "cod12" }).exists?
      puts("daaaaa3")
      # Verifică dacă userul are ambele coduri: cod11 și cod38
      if ComenziProd.joins(:prod).where(user_id: current_user.id, prods: { cod: "cod11" }, validat: "Finalizata").exists? &&
         ComenziProd.joins(:prod).where(user_id: current_user.id, prods: { cod: "cod38" }, validat: "Finalizata").exists?
         puts("daaaaa4")
        return true
      end
      puts("daaaaa5")
      # Verifică dacă userul are ambele coduri: cod13 și cod39
      if ComenziProd.joins(:prod).where(user_id: current_user.id, prods: { cod: "cod13" }, validat: "Finalizata").exists? &&
         ComenziProd.joins(:prod).where(user_id: current_user.id, prods: { cod: "cod39" }, validat: "Finalizata").exists?
        return true
      end
      puts("daaaaa6")
     
      # Află video-ul pe care user-ul dorește să-l acceseze
      video_dorit = Video.find(params[:id])
      puts("daaaaa7")
      puts("video_dorit este: #{video_dorit.link}")
      # Verificăm dacă user-ul curent a plătit pentru video-ul dorit
      if ComenziProd.joins(:prod)
        .where(user_id: current_user.id, prods: { cod: video_dorit.cod }, validat: "Finalizata")
        .where("datasfarsit IS NULL OR datasfarsit >= ?", Date.current)
        .exists?
      
        puts("daaaaa8")
      else
        puts("daaaaa9")
        redirect_to root_path, alert: "Nu ai acces la acest video!" and return
      end
      puts("daaaaa10")
      # Verificăm  coduri_relevante in cazul nostru  "cod49", "cod50", "cod51"  
      coduri_relevante = Video.where(tip: 'nutritie3').where('ordine < ?', 1000).pluck(:cod)
      coduri_relevante.each do |cod|
        if ComenziProd.joins(:prod)
          .where(user_id: current_user.id, prods: { cod: cod }, validat: "Finalizata")
          .where("datasfarsit IS NULL OR datasfarsit >= ?", Date.current)
          .exists?
        
          puts("daaaaa11 pentru #{cod}")
          return true
        end
      end

      tayv2_course = Listacursuri.find_by(nume: 'Nutritie3')
    
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
      if user_course.datasfarsit && user_course.datasfarsit > Date.parse("2024-01-31")
        flash[:alert] = "Accesul la acest curs a expirat."
        redirect_to root_path
      end
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
      redirect_to servicii_path
    end
    

    def set_user4
      # Verifică dacă userul este logat
      unless user_signed_in?
        flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
        redirect_to new_user_session_path # Presupunând că aceasta este calea către login
        return
      end
    
      # Dacă userul are rolul 1, îi dăm acces direct
      return true if current_user.role == 1
    
      # Verifică dacă userul are cod12
      return true if ComenziProd.joins(:prod)
                .where(user_id: current_user.id, prods: { cod: ["cod40", "cod41", "cod42", "cod43", "cod44", "cod45"] }, validat: "Finalizata")
                .exists?
    

    
      
    
      tayt12_course = Listacursuri.find_by(nume: 'tayt12')
    
      if tayt12_course.nil?
        flash[:alert] = "Cursul nu a fost găsit."
        redirect_to root_path
        return
      end
    
      # Găsim înregistrarea din tabelul Cursuri pentru utilizatorul și cursul curent
      user_course = Cursuri.find_by(user_id: current_user.id, listacursuri_id: tayt12_course.id)
    
      unless user_course
        flash[:alert] = "Nu aveți acces la acest curs."
        redirect_to servicii_path
        return
      end
    
      # Verificăm dacă datasfarsit este nil sau dacă data curentă este mai mică sau egală cu datasfarsit
      if user_course.datasfarsit && user_course.datasfarsit > Date.parse("2024-01-31")
        flash[:alert] = "Accesul la acest curs a expirat."
        redirect_to root_path
      end
    end

    def set_user6
      unless user_signed_in?
        flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
        redirect_to new_user_session_path # Presupunând că aceasta este calea către login
        return
      end
    
      if current_user.role == 1
        return true
      end
    
      if current_user.nutritieabsolvit.nil?
        return false
      elsif current_user.nutritieabsolvit >= 2
        return true
      else
        return false
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
      if ComenziProd.joins(:prod).where(user_id: current_user.id, prods: { cod: ["cod11", "cod12", "cod13"] }, validat: "Finalizata").exists?
      return true
      end
    end  


    def require_admin
      unless current_user && current_user.role == 1
        flash[:error] = "Only admins are allowed to access this page."
        redirect_to root_path
      end
    end
end
