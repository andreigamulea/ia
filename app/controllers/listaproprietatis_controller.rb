class ListaproprietatisController < ApplicationController
  before_action :set_listaproprietati, only: %i[ show edit update destroy ]
  before_action :set_user_admin, only: %i[index edit show new destroy]
  # GET /listaproprietatis or /listaproprietatis.json
  def index
    @listaproprietatis = Listaproprietati.all
  end

  # GET /listaproprietatis/1 or /listaproprietatis/1.json
  def show
  end

  # GET /listaproprietatis/new
  def new
    @listaproprietati = Listaproprietati.new
  end

  # GET /listaproprietatis/1/edit
  def edit
  end

  # POST /listaproprietatis or /listaproprietatis.json
  def create
    @listaproprietati = Listaproprietati.new(listaproprietati_params)

    respond_to do |format|
      if @listaproprietati.save
        format.html { redirect_to listaproprietati_url(@listaproprietati), notice: "Listaproprietati was successfully created." }
        format.json { render :show, status: :created, location: @listaproprietati }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @listaproprietati.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /listaproprietatis/1 or /listaproprietatis/1.json
  def update
    respond_to do |format|
      if @listaproprietati.update(listaproprietati_params)
        format.html { redirect_to listaproprietati_url(@listaproprietati), notice: "Listaproprietati was successfully updated." }
        format.json { render :show, status: :ok, location: @listaproprietati }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @listaproprietati.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /listaproprietatis/1 or /listaproprietatis/1.json
  def destroy
    @listaproprietati.destroy

    respond_to do |format|
      format.html { redirect_to listaproprietatis_url, notice: "Listaproprietati was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listaproprietati
      @listaproprietati = Listaproprietati.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def listaproprietati_params
      params.require(:listaproprietati).permit(:idx, :proprietateter, :tipp, :srota, :definire, :sinonime, :selectie, :sel)
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
