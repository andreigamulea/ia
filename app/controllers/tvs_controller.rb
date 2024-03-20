class TvsController < ApplicationController
  before_action :set_tv, only: %i[ show edit update destroy ]

  # GET /tvs or /tvs.json
  def index
    @tvs = Tv.all
  end

  # GET /tvs/1 or /tvs/1.json
  def show
  end

  # GET /tvs/new
  def new
    @tv = Tv.new
  end

  # GET /tvs/1/edit
  def edit
  end

  # POST /tvs or /tvs.json
  def create
    @tv = Tv.new(tv_params)

    respond_to do |format|
      if @tv.save
        format.html { redirect_to tv_url(@tv), notice: "Tv was successfully created." }
        format.json { render :show, status: :created, location: @tv }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tv.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tvs/1 or /tvs/1.json
  def update
    respond_to do |format|
      if @tv.update(tv_params)
        format.html { redirect_to tv_url(@tv), notice: "Tv was successfully updated." }
        format.json { render :show, status: :ok, location: @tv }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tv.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tvs/1 or /tvs/1.json
  def destroy
    @tv.destroy

    respond_to do |format|
      format.html { redirect_to tvs_url, notice: "Tv was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tv
      @tv = Tv.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tv_params
      params.require(:tv).permit(:denumire, :link, :cine, :canal, :datainceput, :orainceput, :mininceput, :datasfarsit, :orasfarsit, :minsfarsit, :user_id, :referinta)
    end
end
