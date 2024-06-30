class DateFacturaresController < ApplicationController
  before_action :set_date_facturare, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: [:new, :index, :destroy, :show]
  before_action :require_admin, only: [:index, :destroy, :show]
  # GET /date_facturares or /date_facturares.json
  def index
    @date_facturares = DateFacturare.all
    @nr_an3= @date_facturares.count
    @necesari_an3=Listacanal3.count-@nr_an3
    puts("sunt in date_facturares_controller.rb index")
    email_exists = Listacanal3.exists?(email: current_user&.email)
    puts("Sa vedem daca exista: #{email_exists}")
    @has_access = current_user && (email_exists || current_user.role == 1)
  end

  # GET /date_facturares/1 or /date_facturares/1.json
  def show
    puts("sunt in date_facturares_controller.rb show")
    email_exists = Listacanal3.exists?(email: current_user&.email)
    puts("Sa vedem daca exista: #{email_exists}")
    @has_access = current_user && (email_exists || current_user.role == 1)
  end

  # GET /date_facturares/new
  def new
    
    puts("sunt in date_facturares_controller.rb new")
    #@date_facturare = DateFacturare.new
    firma_id = Firma.find_by(cod: "cod1").id

    @date_facturare = DateFacturare.new(user_id: current_user.id, email: current_user.email, cod: "cod1",firma_id: firma_id)
    email_exists = Listacanal3.exists?(email: current_user&.email)
    puts("Sa vedem daca exista: #{email_exists}")
    @has_access = current_user && (email_exists || current_user.role == 1)
  end

  # GET /date_facturares/1/edit
 # GET /date_facturares/1/edit
# GET /date_facturares/1/edit
# GET /date_facturares/1/edit
def edit
  # Logare pentru a urmări acțiunea
  puts("Se intră în acțiunea de editare din date_facturares_controller.rb")

  # Verifică dacă emailul utilizatorului curent există în Listacanal3 și loghează rezultatul
  email_exists = current_user && Listacanal3.exists?(email: current_user.email)
  puts("Există emailul: #{email_exists}")

  # Asigură-te că există un utilizator autentificat înainte de a verifica rolul și proprietatea resursei
  if current_user
    # Verifică dacă utilizatorul curent este administrator sau dacă este proprietarul resursei și emailul său există în Listacanal3
    if current_user.role == 1 || (current_user.role == 0 && current_user.id == @date_facturare.user_id && email_exists)
      # Utilizatorul are acces: fie este administrator, fie este proprietarul resursei și emailul său există în Listacanal3
      @has_access = true
    else
      # Utilizatorul nu are dreptul de a edita această resursă, îl redirecționăm cu un avertisment
      redirect_to(root_url, alert: 'Nu aveți autorizația necesară pentru a accesa această pagină.')
      return # Oprește execuția ulterioară a acestei acțiuni
    end
  else
    # Nu există un utilizator autentificat, redirecționează către pagina de login
    redirect_to(new_user_session_url, alert: 'Trebuie să vă autentificați pentru a accesa această pagină.')
    return # Oprește execuția ulterioară a acestei acțiuni
  end
end



  # POST /date_facturares or /date_facturares.json
  def create
    puts("sunt in date_facturares_controller.rb show")
    email_exists = Listacanal3.exists?(email: current_user&.email)
    puts("Sa vedem daca exista: #{email_exists}")
    @has_access = current_user && (email_exists || current_user.role == 1)
    puts("sunt in date_facturares_controller.rb create")
    @date_facturare = DateFacturare.new(date_facturare_params)
  
    respond_to do |format|
      if @date_facturare.save
        format.html { redirect_to edit_date_facturare_path(@date_facturare), notice: "Date facturare was successfully created and can now be reviewed or edited." }
        format.json { render :show, status: :created, location: @date_facturare }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @date_facturare.errors, status: :unprocessable_entity }
      end
    end
  end
  

  # PATCH/PUT /date_facturares/1 or /date_facturares/1.json
  def update
    puts("sunt in date_facturares_controller.rb update")
    email_exists = Listacanal3.exists?(email: current_user&.email)
    puts("Sa vedem daca exista: #{email_exists}")
    @has_access = current_user && (email_exists || current_user.role == 1)
    puts("sunt in date_facturares_controller.rb update")
    
    respond_to do |format|
      if @date_facturare.update(date_facturare_params)
        format.html { redirect_to edit_date_facturare_path(@date_facturare), notice: "Date facturare was successfully created and can now be reviewed or edited." }
        format.json { render :show, status: :ok, location: @date_facturare }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @date_facturare.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /date_facturares/1 or /date_facturares/1.json
  def destroy
    @date_facturare.destroy

    respond_to do |format|
      format.html { redirect_to date_facturares_url, notice: "Date facturare was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  def export_datefacturare
    date_facturares = DateFacturare.all.order(:id)  # Assuming you want to export all records

    # Create a new workbook
    workbook = RubyXL::Workbook.new
    worksheet = workbook[0]
    worksheet.sheet_name = 'Date Facturare'

    # Define headers for the spreadsheet
    headers = ['User ID', 'Firma ID', 'Email', 'Prenume', 'Nume', 'Nume Companie', 'CUI', 'Țara', 'Cod Poștal', 'Stradă', 'Număr', 'Alte Date', 'Telefon', 'Adresa Email', 'Localitate', 'Județ', 'Grupa 2324', 'CPA', 'COD']
    headers.each_with_index do |header, index|
      worksheet.add_cell(0, index, header)
    end

    # Fill the spreadsheet with date facturare data
    date_facturares.each_with_index do |date_facturare, index|
      worksheet.add_cell(index + 1, 0, date_facturare.user_id)
      worksheet.add_cell(index + 1, 1, date_facturare.firma_id)
      worksheet.add_cell(index + 1, 2, date_facturare.email)
      worksheet.add_cell(index + 1, 3, date_facturare.prenume)
      worksheet.add_cell(index + 1, 4, date_facturare.nume)
      worksheet.add_cell(index + 1, 5, date_facturare.numecompanie)
      worksheet.add_cell(index + 1, 6, date_facturare.cui)
      worksheet.add_cell(index + 1, 7, date_facturare.tara)
      worksheet.add_cell(index + 1, 8, date_facturare.codpostal)
      worksheet.add_cell(index + 1, 9, date_facturare.strada)
      worksheet.add_cell(index + 1, 10, date_facturare.numar)
      worksheet.add_cell(index + 1, 11, date_facturare.altedate)
      worksheet.add_cell(index + 1, 12, date_facturare.telefon)
      worksheet.add_cell(index + 1, 13, date_facturare.adresaemail)
      worksheet.add_cell(index + 1, 14, date_facturare.localitate)
      worksheet.add_cell(index + 1, 15, date_facturare.judet)
      worksheet.add_cell(index + 1, 16, date_facturare.grupa2324)
      worksheet.add_cell(index + 1, 17, date_facturare.cpa)
      worksheet.add_cell(index + 1, 18, date_facturare.cod)
    end

    # Save the workbook to a file
    file_path = Rails.root.join('tmp', 'date_facturare.xlsx')
    workbook.write(file_path)

    # Send the file to the user
    send_file(file_path, filename: 'date_facturare.xlsx', type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_date_facturare
      @date_facturare = DateFacturare.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def date_facturare_params
      params.require(:date_facturare).permit(
        :user_id, :firma_id, :email, :prenume, :nume, :numecompanie, :cui, :tara, 
        :codpostal, :strada, :numar, :altedate, :telefon, :adresaemail, :localitate, 
        :judet, :grupa2324, :cpa, :cod, :cnp
      )
    end
    
    def require_admin
      unless current_user && current_user.role == 1
        flash[:error] = "Only admins are allowed to access this page."
        redirect_to root_path
      end
  end
end
