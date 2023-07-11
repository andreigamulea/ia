class ListaVegetalesController < ApplicationController
  before_action :set_lista_vegetale, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: %i[index ] #verifica daca utilizatorul este autentificat
  before_action :set_user, only: %i[index show]
  before_action :set_user1, only: %i[edit update destroy]
  # GET /lista_vegetales or /lista_vegetales.json
  def index
    @page_title = "Lista vegetale"

    if params[:search_type] == "eq"
        @lista_vegetales = ListaVegetale.where('specie ~* ? OR sinonime ~* ? OR parteutilizata ~* ?', "\\y#{params[:search_term]}\\y", "\\y#{params[:search_term]}\\y", "\\y#{params[:search_term]}\\y").page(params[:page]).per(25)
        @q = @lista_vegetales.ransack(params[:q])
        @search_term = params[:search_term] 
    else
        @q = ListaVegetale.ransack({specie_cont: params[:search_term], sinonime_cont: params[:search_term], parteutilizata_cont: params[:search_term], m: 'or'})
        @lista_vegetales = @q.result.distinct.order(:id).page(params[:page]).per(25)
        @search_term = params[:search_term]
    end
    # Numărul total de înregistrări și numărul de pagini
    @total_records = @lista_vegetales.total_count

    @total_pages = (@total_records / 10.0).ceil
end



  
  

  # GET /lista_vegetales/1 or /lista_vegetales/1.json
  def show
  end

  # GET /lista_vegetales/new
  def new
    @lista_vegetale = ListaVegetale.new
  end

  # GET /lista_vegetales/1/edit
  def edit
  end

  # POST /lista_vegetales or /lista_vegetales.json
  def create
    @lista_vegetale = ListaVegetale.new(lista_vegetale_params)

    respond_to do |format|
      if @lista_vegetale.save
        format.html { redirect_to lista_vegetale_url(@lista_vegetale), notice: "Lista vegetale was successfully created." }
        format.json { render :show, status: :created, location: @lista_vegetale }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @lista_vegetale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lista_vegetales/1 or /lista_vegetales/1.json
  def update
    respond_to do |format|
      if @lista_vegetale.update(lista_vegetale_params)
        format.html { redirect_to lista_vegetale_url(@lista_vegetale), notice: "Lista vegetale was successfully updated." }
        format.json { render :show, status: :ok, location: @lista_vegetale }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @lista_vegetale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lista_vegetales/1 or /lista_vegetales/1.json
  def destroy
    @lista_vegetale.destroy

    respond_to do |format|
      format.html { redirect_to lista_vegetales_url, notice: "Lista vegetale was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lista_vegetale
      @lista_vegetale = ListaVegetale.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def lista_vegetale_params
      params.require(:lista_vegetale).permit(:specie, :sinonime, :parteutilizata, :mentiunirestrictii, :numar, :dataa)
    end
    def set_user
      # Verifica daca userul este logat
      if current_user
        # Verifica daca userul este admin sau asociat cu cursul "Nutritie"
        if current_user.role == 1 || current_user.listacursuri.any? { |curs| curs.nume == "Lista vegetale" }
          # Utilizatorul are acces la resursa
        else
          # Utilizatorul nu are acces la resursa
          flash[:alert] = "Nu ai acces la această resursă."
          redirect_to servicii_path
        end
      else
        # Utilizatorul nu este logat
        flash[:alert] = "Trebuie să te autentifici pentru a accesa această resursă."
        redirect_to login_path
      end
    end
    def set_user1
      # Verifica daca userul este logat
      if current_user
        # Verifica daca userul este admin sau asociat cu cursul "Nutritie"
        if current_user.role == 1 
          # Utilizatorul are acces la resursa
        else
          # Utilizatorul nu are acces la resursa
          flash[:alert] = "Nu ai acces la această resursă."
          redirect_to lista_vegetales_path
        end
      else
        # Utilizatorul nu este logat
        flash[:alert] = "Trebuie să te autentifici pentru a accesa această resursă."
        redirect_to root_path
      end
    end
end
