class SrotaController < ApplicationController
  before_action :set_srotum, only: %i[ show edit update destroy ]
  before_action :set_user_admin, only: %i[index edit show new destroy]
  # GET /srota or /srota.json
  def index
    @srota = Srotum.all
  end

  # GET /srota/1 or /srota/1.json
  def show
  end

  # GET /srota/new
  def new
    @srotum = Srotum.new
  end

  # GET /srota/1/edit
  def edit
  end

  # POST /srota or /srota.json
  def create
    @srotum = Srotum.new(srotum_params)

    respond_to do |format|
      if @srotum.save
        format.html { redirect_to srotum_url(@srotum), notice: "Srotum was successfully created." }
        format.json { render :show, status: :created, location: @srotum }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @srotum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /srota/1 or /srota/1.json
  def update
    respond_to do |format|
      if @srotum.update(srotum_params)
        format.html { redirect_to srotum_url(@srotum), notice: "Srotum was successfully updated." }
        format.json { render :show, status: :ok, location: @srotum }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @srotum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /srota/1 or /srota/1.json
  def destroy
    @srotum.destroy

    respond_to do |format|
      format.html { redirect_to srota_url, notice: "Srotum was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_srotum
      @srotum = Srotum.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def srotum_params
      params.require(:srotum).permit(:codsrota, :codsr, :numesrota, :numescurt, :explicatie, :origine, :parti, :functii, :observatie)
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
end
