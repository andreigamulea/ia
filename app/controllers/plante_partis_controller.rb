class PlantePartisController < ApplicationController
  before_action :set_plante_parti, only: %i[ show edit update destroy ]
  before_action :set_user_admin, only: %i[index edit show new destroy]
  # GET /plante_partis or /plante_partis.json
  def index
    @plante_partis = PlanteParti.all
  end

  # GET /plante_partis/1 or /plante_partis/1.json
  def show
  end

  # GET /plante_partis/new
  def new
    @plante_parti = PlanteParti.new
  end

  # GET /plante_partis/1/edit
  def edit
  end

  # POST /plante_partis or /plante_partis.json
  def create
    @plante_parti = PlanteParti.new(plante_parti_params)

    respond_to do |format|
      if @plante_parti.save
        format.html { redirect_to plante_parti_url(@plante_parti), notice: "Plante parti was successfully created." }
        format.json { render :show, status: :created, location: @plante_parti }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @plante_parti.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plante_partis/1 or /plante_partis/1.json
  def update
    respond_to do |format|
      if @plante_parti.update(plante_parti_params)
        format.html { redirect_to plante_parti_url(@plante_parti), notice: "Plante parti was successfully updated." }
        format.json { render :show, status: :ok, location: @plante_parti }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @plante_parti.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plante_partis/1 or /plante_partis/1.json
  def destroy
    @plante_parti.destroy

    respond_to do |format|
      format.html { redirect_to plante_partis_url, notice: "Plante parti was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plante_parti
      @plante_parti = PlanteParti.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def plante_parti_params
      params.require(:plante_parti).permit(:idx, :cpl, :parte, :part, :clasa, :invpp, :tippp, :recomandari, :textsursa, :starereprez, :z, :healthrel, :compozitie, :etich, :healthrelrom, :propspeciale, :selectie, :lucru, :s, :sel, :index2, :ordvol, :selpz, :selpzn, :sels, :selz, :selnr, :t10, :t11, :t12, :t13, :t14, :t15, :t16, :b, :r, :c, :imp, :testat, :g1, :g2, :g3, :g4, :g5, :g6, :vir, :vip, :imaginepp)
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
