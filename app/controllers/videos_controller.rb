class VideosController < ApplicationController
  before_action :set_video, only: %i[ show edit update destroy ]
  before_action :set_user, only: %i[ show edit update destroy]
  before_action :set_user1, only: %i[tayv2 myvideo1]
  # GET /videos or /videos.json
  def index
    @videos = Video.all
  end
  def myvideo   
    @myvideo = Video.first.link    
  end
  def myvideo1
    @myvideo1 = Video.find(params[:id]).nume
    @myvideo = Video.find(params[:id])[:link]
  end

  def tayv2
    @myvideo = Video.where(tip: 'tayv2').order(ordine: :asc)
  end
  
  
  
  
  # GET /videos/1 or /videos/1.json
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
      params.require(:video).permit(:nume, :descriere, :sursa, :link, :tip, :ordine)
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
    
end
