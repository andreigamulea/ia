class VideosController < ApplicationController
  before_action :set_video, only: %i[ show edit update destroy ]

  # GET /videos or /videos.json
  def index
    @videos = Video.all
  end
  def myvideo
    begin
      youtube = Google::Apis::YoutubeV3::YouTubeService.new
      u = User.find_by(email: 'ayushcellromania@gmail.com')
      #u=current_user
      youtube.authorization = u.google_token
      puts("bbbbbbbbbbbbbb")
      puts(youtube.authorization)

      puts("bbbbbbbbbbbbbb")
      #video_id = 'cyZrBoF7bjs'  # ID-ul unui videoclip privat ayusch
      video_id = 'PqvgPC8u7eQ'  # ID-ul unui videoclip privat ayusch1
      #video_id = 'lp_SV-kmLmc'  # ID-ul unui videoclip public
      @video = youtube.list_videos('snippet, contentDetails, player', id: video_id).items.first
  
    rescue Google::Apis::ClientError => e
      puts "Caught error #{e.message}: #{e.status_code}"
  
      if e.status_code == 401
        # Dacă tokenul este expirat, reîmprospătează-l și reîncearcă
        current_user.refresh_google_token!
        retry
      else
        redirect_to videos_path
      end
    end
  end
  def myvideo1
    #@video=VideoPlayer::player("https://youtu.be/pqKdFhDoJfQ", "1200", "800", true) #public
    @video=VideoPlayer::player("https://youtu.be/wFsOFLPw3V8", "1200", "800", true) #privat
    
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
      params.require(:video).permit(:nume, :descriere, :sursa, :link)
    end
end
