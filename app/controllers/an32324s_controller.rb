class An32324sController < ApplicationController
  before_action :set_an32324, only: %i[ show edit update destroy ]

  # GET /an32324s or /an32324s.json
  def index
    @an32324s = An32324.all
  end

  # GET /an32324s/1 or /an32324s/1.json
  def show
  end

  # GET /an32324s/new
  def new
    @an32324 = An32324.new
  end

  # GET /an32324s/1/edit
  def edit
  end

  # POST /an32324s or /an32324s.json
  def create
    @an32324 = An32324.new(an32324_params)

    respond_to do |format|
      if @an32324.save
        format.html { redirect_to an32324_url(@an32324), notice: "An32324 was successfully created." }
        format.json { render :show, status: :created, location: @an32324 }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @an32324.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /an32324s/1 or /an32324s/1.json
  def update
    respond_to do |format|
      if @an32324.update(an32324_params)
        format.html { redirect_to an32324_url(@an32324), notice: "An32324 was successfully updated." }
        format.json { render :show, status: :ok, location: @an32324 }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @an32324.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /an32324s/1 or /an32324s/1.json
  def destroy
    @an32324.destroy

    respond_to do |format|
      format.html { redirect_to an32324s_url, notice: "An32324 was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  def preluarean3
    An32324.destroy_all
  
    xlsx = if Rails.env.production?
             Roo::Spreadsheet.open('/opt/render/project/src/app/fisierele/an32324.xlsx')
           else
             Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'an32324.xlsx'))
           end
  
    xlsx.each_row_streaming(offset: 1, pad_cells: true) do |row|
      email = row[0]&.value&.to_s&.strip&.downcase
      next if email.nil?  # Sari peste rândurile unde email-ul este nil
  
      name = row[1]&.value&.to_s&.strip
      telefon = row[2]&.value&.to_s&.strip
      sep = row[3]&.value&.to_s&.strip.presence
      oct = row[4]&.value&.to_s&.strip.presence
      nov = row[5]&.value&.to_s&.strip.presence
      dec = row[6]&.value&.to_s&.strip.presence
      ian = row[7]&.value&.to_s&.strip.presence
      feb = row[8]&.value&.to_s&.strip.presence
      mar = row[9]&.value&.to_s&.strip.presence
      apr = row[10]&.value&.to_s&.strip.presence
      mai = row[11]&.value&.to_s&.strip.presence
      iun = row[12]&.value&.to_s&.strip.presence
      iul = row[13]&.value&.to_s&.strip.presence
      pret = row[14]&.value&.to_f
  
      # Verificăm dacă prețul este nul sau zero
      #next if pret.nil? || pret == 0.0
  
      # Crearea și salvarea noii înregistrări
      An32324.create!(
        email: email,
        nume: name,
        telefon: telefon,
        sep: sep,
        oct: oct,
        nov: nov,
        dec: dec,
        ian: ian,
        feb: feb,
        mar: mar,
        apr: apr,
        mai: mai,
        iun: iun,
        iul: iul,
        pret: pret
      )
    end
    redirect_to root_path
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_an32324
      @an32324 = An32324.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def an32324_params
      params.require(:an32324).permit(:email, :nume, :telefon, :sep, :oct, :nov, :dec, :ian, :feb, :mar, :apr, :mai, :iun, :iul, :pret)
    end
end
