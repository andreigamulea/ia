class ValorinutritionalesController < ApplicationController
  include ApplicationHelper
  before_action :set_valorinutritionale, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: %i[index ] #verifica daca utilizatorul este autentificat
  before_action :set_user, only: %i[index show edit update destroy]

  ## GET /valorinutritionales or /valorinutritionales.json
  
  def index

    #@q = Valorinutritionale.ransack(params[:q])
    #@valorinutritionales = @q.result.page(params[:page]).per(3)
   
    @valorinutritionales = Valorinutritionale.page(params[:page]).per(3)
    @selected_valorinutritionales = session[:selected_values]&.map { |v| Valorinutritionale.find_by(id: v[:id]) }&.compact || []
    
    @total_values = {
      calorii: 0,
      proteine: 0,
      lipide: 0,
      carbohidrati: 0,
      fibre: 0
    }
  
    @selected_valorinutritionales.each do |valorinutritionale|
      value = session[:selected_values].find { |v| v[:id] == valorinutritionale.id.to_s }[:value]
      @total_values[:calorii] += value * valorinutritionale.calorii / 100
      @total_values[:proteine] += value * valorinutritionale.proteine / 100
      @total_values[:lipide] += value * valorinutritionale.lipide / 100
      @total_values[:carbohidrati] += value * valorinutritionale.carbohidrati / 100
      @total_values[:fibre] += value * valorinutritionale.fibre / 100
    end
    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end 
  def search
    query = params[:query]
    @valorinutritionales = Valorinutritionale.where("aliment ILIKE ?", "%#{query}%").page(params[:page]).per(3)
    
    respond_to do |format|
      #format.turbo_stream { render turbo_stream: turbo_stream.replace("valorinutritionales_table", partial: "valorinutritionales/valorinutritionales_table") }
      format.turbo_stream { render turbo_stream: turbo_stream.replace("valorinutritionales_table", partial: "valorinutritionales_table", locals: { valorinutritionales: @valorinutritionales }) }
      format.html { redirect_to valorinutritionales_path }
    end
  end
  
  
  def select_valorinutritionales
    id = params[:id].to_i
    value = params[:value]
  
    if session[:selected_valorinutritionales].nil?
      session[:selected_valorinutritionales] = []
    end
  
    # Verificați dacă ID-ul există deja în sesiune și actualizați valoarea
    found = false
    session[:selected_valorinutritionales].each do |item|
      if item[:id] == id
        item[:value] = value
        found = true
        break
      end
    end
  
    # Dacă ID-ul nu există în sesiune, adăugați-l
    unless found
      session[:selected_valorinutritionales] << { id: id, value: value }
    end
  
    @valorinutritional = Valorinutritionale.find(id)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to valorinutritionales_url, notice: "Valoarea a fost adăugată cu succes." }
    end
  end
  
  
 
  def reset_session_data
    session[:selected_valorinutritionales] = []
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace(:valorinutritionales_results, partial: 'valorinutritionales/valorinutritionales_results') }
    end
  end
  
  def delete_selected
    id = params[:id].to_i
    session[:selected_valorinutritionales].delete_if { |item| item[:id] == id || item["id"] == id }
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("valorinutritionales_results", partial: "valorinutritionales/valorinutritionales_results") }
      format.html { redirect_to valorinutritionales_path }
    end
  end
  
  
  
 
  def valorinutritionales_table
    @valorinutritionales = Valorinutritionale.all
    render partial: 'valorinutritionales_table'
  end
  def index_turbo_stream
    @valorinutritionales = Valorinutritionale.order(:aliment).paginate(page: params[:page], per_page: 15)

    render turbo_stream: turbo_stream.replace(
      "valorinutritionales",
      partial: "valorinutritionales/valorinutritionales_table",
      locals: { valorinutritionales: @valorinutritionales }
    )
  end 

  # GET /valorinutritionales/1 or /valorinutritionales/1.json
  def show
  end

  # GET /valorinutritionales/new
  def new
    @valorinutritionale = Valorinutritionale.new
  end

  # GET /valorinutritionales/1/edit
  def edit
  end

  # POST /valorinutritionales or /valorinutritionales.json
  def create
    @valorinutritionale = Valorinutritionale.new(valorinutritionale_params)

    respond_to do |format|
      if @valorinutritionale.save
        format.html { redirect_to valorinutritionale_url(@valorinutritionale), notice: "Valorinutritionale was successfully created." }
        format.json { render :show, status: :created, location: @valorinutritionale }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @valorinutritionale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /valorinutritionales/1 or /valorinutritionales/1.json
  def update
    respond_to do |format|
      if @valorinutritionale.update(valorinutritionale_params)
        format.html { redirect_to valorinutritionale_url(@valorinutritionale), notice: "Valorinutritionale was successfully updated." }
        format.json { render :show, status: :ok, location: @valorinutritionale }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @valorinutritionale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /valorinutritionales/1 or /valorinutritionales/1.json
  def destroy
    @valorinutritionale.destroy

    respond_to do |format|
      format.html { redirect_to valorinutritionales_url, notice: "Valorinutritionale was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  
  def process_selected
    # Preluăm datele primite prin POST
    if params[:selected_values].present?
      
      @selected_ids = params[:selected_values].map { |value| value[:id] }
      @valorinutritionale_values = params[:selected_values].map { |value| { id: value[:id], value: value[:value] } }
    else
      @selected_ids = []
      @valorinutritionale_values = {}
    end
    
  
    # Creăm un array gol pentru a adăuga valorile selectate
    @selected_valorinutritionales = []
    @selected_ids.each do |id|
      @selected_valorinutritionales << Valorinutritionale.find(id)
    end
    
    # Verificăm dacă există valori pentru a fi prelucrate
    if @selected_valorinutritionales.empty?
      flash[:notice] = "Nu ați selectat nicio valoare nutrițională"
      redirect_to valorinutritionales_path
    else
      respond_to do |format|
        #format.html { render :show_selected ,valorinutritionales:@valorinutritionale_values}
        format.html { redirect_to show_selected_path(valorinutritionales:@valorinutritionale_values) }
      end
      #redirect_to show_selected_path(valorinutritionales:@valorinutritionale_values)
 
    end
  end

 


  def show_selected
    selected_values = params[:valorinutritionales]
    selected_valorinutritionale_ids = selected_values.map { |v| v["id"].to_i }
    @selected_valorinutritionales = Valorinutritionale.where(id: selected_valorinutritionale_ids)
    
    @valorinutritionale_values = {}
    selected_values.each do |v|
      id = v["id"].to_i
      value = v["value"].to_f
      valorinutritionale = Valorinutritionale.find(id)
      @valorinutritionale_values[id.to_i] = { value: value.to_f, nutrient: valorinutritionale.nutrient }
      
    end
  end
  
  def show_selected
    selected_values = params[:valorinutritionales]
    selected_valorinutritionale_ids = selected_values.map { |v| v["id"].to_i }
    @selected_valorinutritionales = Valorinutritionale.where(id: selected_valorinutritionale_ids)
  
    @valorinutritionale_values = {}
    selected_values.each do |v|
      id = v["id"].to_i
      value = v["value"].to_f
      valorinutritionale = Valorinutritionale.find(id)
      @valorinutritionale_values[id] ||= {}
      @valorinutritionale_values[id][:value] ||= 0
      @valorinutritionale_values[id][:value] += value.to_f
    end
  
    @total_values = {}
    @selected_valorinutritionales.each do |valorinutritionale|
      id = valorinutritionale.id
      @total_values[:calorii] ||= 0
      @total_values[:calorii] += valorinutritionale.calorii * @valorinutritionale_values[id][:value] / 100
      @total_values[:proteine] ||= 0
      @total_values[:proteine] += valorinutritionale.proteine * @valorinutritionale_values[id][:value] / 100
      @total_values[:lipide] ||= 0
      @total_values[:lipide] += valorinutritionale.lipide * @valorinutritionale_values[id][:value] / 100
      @total_values[:carbohidrati] ||= 0
      @total_values[:carbohidrati] += valorinutritionale.carbohidrati * @valorinutritionale_values[id][:value] / 100
      @total_values[:fibre] ||= 0
      @total_values[:fibre] += valorinutritionale.fibre * @valorinutritionale_values[id][:value] / 100
    end
  end
  
  



  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_selected_values_to_session(selected_values)
      session[:selected_values] = selected_values.map do |value|
        { id: value[:id], value: value[:value] }
      end
    end
    def set_valorinutritionale
      @valorinutritionale = Valorinutritionale.find(params[:id])
      @selected_values = params[:selected_values]
      params.permit(:id, selected_values_attributes: [:id, :value])
    end
    def set_user
      # Verifica daca userul este logat
      if current_user
        # Verifica daca userul este admin sau asociat cu cursul "Nutritie"
        if current_user.role == 1 || current_user.listacursuri.any? { |curs| curs.nume == "Nutritie" }
          # Utilizatorul are acces la resursa
        else
          # Utilizatorul nu are acces la resursa
          flash[:alert] = "Nu ai acces la această resursă."
          redirect_to root_path
        end
      else
        # Utilizatorul nu este logat
        flash[:alert] = "Trebuie să te autentifici pentru a accesa această resursă."
        redirect_to login_path
      end
    end
    

    # Only allow a list of trusted parameters through.
    def valorinutritionale_params
      params.require(:valorinutritionale).permit(:cod, :aliment, :calorii, :proteine, :lipide, :carbohidrati, :fibre)
    end
end
