class ValorinutritionalesController < ApplicationController
  include ApplicationHelper
  before_action :set_valorinutritionale, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: %i[index ] #verifica daca utilizatorul este autentificat
  before_action :set_user, only: %i[index show edit update destroy]
  before_action :set_user1, only: %i[aplicatie]

  before_action :track_ahoy_visit
  skip_before_action :verify_authenticity_token, only: [:track]
  protect_from_forgery except: :track

  ## GET /valorinutritionales or /valorinutritionales.json
  def track
    # prelucrează datele primite
    event_data = JSON.parse(request.body.read)
    event_name = event_data["event"]
    event_properties = { "page" => event_data["page"] }
    
    # obtinem tokenul de vizită al utilizatorului curent
    visit_token = ahoy.visit_token
    
    # căutăm obiectul Visit asociat cu tokenul de vizită
    visit = Ahoy::Visit.find_by(visit_token: visit_token)
    
    if visit.nil?
      # nu am putut găsi un obiect Visit asociat cu acest utilizator
      # aici puteți decide cum să gestionați această situație, de exemplu prin crearea unui nou obiect Visit
      head :unprocessable_entity
    else
      if current_user && current_user.id
        # avem un obiect Visit și un utilizator autentificat, acum putem crea un eveniment
        Ahoy::Event.create!(
          visit_id: visit.id,
          user_id: current_user.id,  # presupunem că există o metodă current_user care returnează utilizatorul curent
          name: event_name,
          properties: event_properties,
          time: Time.current
        )
    
        head :ok  # răspunde cu status 200 OK
      else
        # current_user este nil sau nu are un id valid
        # aici puteți decide cum să gestionați această situație
        head :unauthorized  # sau un alt status HTTP adecvat
      end
    end
    
  end
  
  
  def aplicatie #pagina de produs-  Descriere app Valori nutritionale. posibilitate de cumparare

    @prods = Prod.where(status: 'activ').where(curslegatura: 'Nutritie')
  end

  def index #app Valori Nutritionale
    @page_title = "Valori Nutritionale"
    
    @search_term = params[:search_term] # add this line

    if params[:search_type] == "eq"
      @valorinutritionales = Valorinutritionale.where('aliment ~* ?', "\\y#{params[:search_term]}\\y").page(params[:page]).per(10)
      @q = @valorinutritionales.ransack(params[:q])
    else
      @q = Valorinutritionale.ransack(aliment_cont: params[:search_term])
      @valorinutritionales = @q.result.distinct.order(:id).page(params[:page]).per(10)
    end
    @total_records = @valorinutritionales.total_count
    @nrpag=@valorinutritionales.total_count
    @total_values = {
      calorii: 0,
      proteine: 0,
      lipide: 0,
      carbohidrati: 0,
      fibre: 0
    }
  
    if @selected_valorinutritionales.present?
      @selected_valorinutritionales.each do |valorinutritionale|
        value = session[:selected_values].find { |v| v[:id] == valorinutritionale.id.to_s }[:value]
        @total_values[:calorii] += value * valorinutritionale.calorii / 100
        @total_values[:proteine] += value * valorinutritionale.proteine / 100
        @total_values[:lipide] += value * valorinutritionale.lipide / 100
        @total_values[:carbohidrati] += value * valorinutritionale.carbohidrati / 100
        @total_values[:fibre] += value * valorinutritionale.fibre / 100
      end
    end
    
    respond_to do |format|
      format.turbo_stream
      format.html
    end
    @user_page_visit_times = {}

    Ahoy::Event.where(name: "$page_load", user_id: current_user.id).find_each do |load_event|
      unload_event = Ahoy::Event.where(name: "$page_unload", user_id: current_user.id, properties: load_event.properties).first
      if unload_event
        page_name = load_event.properties["page"]
        visit_time = unload_event.time - load_event.time
        @user_page_visit_times[page_name] ||= 0
        @user_page_visit_times[page_name] += visit_time
      end
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
    def set_user #seteaza userul ca are acces la aplicatia Valori Nutritionale
      @has_access = false



      # Verifica daca userul este logat
      if current_user


      ########################
      @condition2 = false
      special_emails = ['cristina.nedescu@gmail.com','derynola@gmx.com','lucianpop1@yahoo.fr']

      # Verificare dacă utilizatorul curent are un email special
      if special_emails.include?(current_user.email)
        @condition2 = true
      end

      # Logica pentru produsele achiziționate
      purchased_prods = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
        .joins(:prod)
        .where(prods: { curslegatura: 'nutritie', status: 'activ' })
        .pluck('prods.cod', 'datainceput', 'datasfarsit')

      purchased_prods1 = ComenziProd1.where(user_id: current_user.id, validat: 'Finalizata')
        .joins(:prod)
        .where(prods: { curslegatura: 'nutritie', status: 'activ' })
        .pluck('prods.cod', 'datainceput', 'datasfarsit')

      valid_prods = (purchased_prods + purchased_prods1).select do |prod|
        prod_end_date = prod[2] # presupunem că 'datasfarsit' este al treilea element din array
        puts("prod_end_date=#{prod_end_date}") # Mutat în interiorul blocului
        prod_end_date && prod_end_date >= Date.today
      end.map(&:first) # preluăm doar codurile produselor valide

      # Setare @has_access și @condition2 în funcție de produsele valide
      unless valid_prods.empty?
        @has_access = true
        @condition2 = true
      end
      ########################

        # Verifica daca userul este admin sau asociat cu cursul "Nutritie"
        if current_user && (current_user.role == 1 || @condition2 || current_user.cursuri.any? { |curs| curs.listacursuri.nume == "Nutritie" && (curs.datasfarsit.nil? || Date.current <= curs.datasfarsit) })
        @has_access = true
        puts("da are acces")
        # Utilizatorul are acces la resursa
        elsif Date.today < Date.new(2024, 12, 31) && UserModulecursuri.exists?(user_id: current_user.id)
          @has_access = true
        elsif current_user && Date.today < Date.new(2024, 12, 31) && ComenziProd.joins(:prod).where(user_id: current_user.id, prod: { cod: ['cod11', 'cod12', 'cod13', 'cod72', 'cod73'] }, validat: "Finalizata").exists?
          @has_access = true # aici dau acces la Calculator Valori N pana la 31.12.2024 - si mai jos
          #pt ca si cei care platesc nutritie4 sa aiba acces adaug mai sus produsele: cod88 de exemlu
          puts("utilizatorul are o comandă finalizată pentru un produs specific")
          # Utilizatorul are o comandă finalizată pentru un produs specific
        else
          # Utilizatorul nu are acces la resursa
          puts("nu, nu are acces1")
          flash[:alert] = "Nu ai acces la această resursă."
          redirect_to aplicatie_path
        end
      else
        # Utilizatorul nu este logat
        flash[:alert] = "Trebuie să te autentifici pentru a accesa această resursă."
        redirect_to new_user_session_with_return_path('aplicatie nutritie')
      end
      
    end
    def set_user1 #seteaza userul ca are acces la aplicatia Valori Nutritionale
      @has_access = false
      # Verifica daca userul este logat
      if current_user

      ########################
        @condition2 = false
        special_emails = ['cristina.nedescu@gmail.com','derynola@gmx.com','lucianpop1@yahoo.fr']

        # Verificare dacă utilizatorul curent are un email special
        if special_emails.include?(current_user.email)
          @condition2 = true
        end

        # Logica pentru produsele achiziționate
        purchased_prods = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
          .joins(:prod)
          .where(prods: { curslegatura: 'nutritie', status: 'activ' })
          .pluck('prods.cod', 'datainceput', 'datasfarsit')

        purchased_prods1 = ComenziProd1.where(user_id: current_user.id, validat: 'Finalizata')
          .joins(:prod)
          .where(prods: { curslegatura: 'nutritie', status: 'activ' })
          .pluck('prods.cod', 'datainceput', 'datasfarsit')

        valid_prods = (purchased_prods + purchased_prods1).select do |prod|
          prod_end_date = prod[2] # presupunem că 'datasfarsit' este al treilea element din array
          puts("prod_end_date=#{prod_end_date}") # Mutat în interiorul blocului
          prod_end_date && prod_end_date >= Date.today
        end.map(&:first) # preluăm doar codurile produselor valide

        # Setare @has_access și @condition2 în funcție de produsele valide
        unless valid_prods.empty?
          @has_access = true
          @condition2 = true
        end
        ########################

        # Verifica daca userul este admin sau asociat cu cursul "Nutritie"
        if current_user && (current_user.role == 1 || @condition2 || current_user.cursuri.any? { |curs| curs.listacursuri.nume == "Nutritie" && (curs.datasfarsit.nil? || Date.current <= curs.datasfarsit) })
        @has_access = true
        puts("da are acces2")
        # Utilizatorul are acces la resursa
        elsif Date.today < Date.new(2024, 12, 31) && UserModulecursuri.exists?(user_id: current_user.id)
          @has_access = true
          puts("utilizatorul este din UserModulecursuri")
        elsif current_user && Date.today < Date.new(2024, 12, 31) && ComenziProd.joins(:prod).where(user_id: current_user.id, prod: { cod: ['cod11', 'cod12', 'cod13', 'cod72', 'cod73'] }, validat: "Finalizata").exists?
            @has_access = true # aici dau acces la Calculator Valori N pana la 31.12.2024 - si mai sus
            #pt ca si cei care platesc nutritie4 sa aiba acces adaug mai sus produsele: cod88 de exemlu
            puts("utilizatorul are o comandă finalizată pentru un produs specific")
            # Utilizatorul are o comandă finalizată pentru un produs specific
        else
          # Utilizatorul nu are acces la resursa
          puts("nu, nu are acces3")
          flash[:alert] = "Nu ai acces la această resursă."
          
        end
      else
        # Utilizatorul nu este logat
        #flash[:alert] = "Trebuie să te autentifici pentru a accesa această resursă."
        #redirect_to new_user_session_with_return_path('aplicatie nutritie')
      end
      
    end

    # Only allow a list of trusted parameters through.
    def valorinutritionale_params
      params.require(:valorinutritionale).permit(:cod, :aliment, :calorii, :proteine, :lipide, :carbohidrati, :fibre, :observatii)
    end
    def track_ahoy_visit
      unless ahoy.visit
        ahoy.track_visit
      end
    end
    
end
