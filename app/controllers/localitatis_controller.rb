class LocalitatisController < ApplicationController
  before_action :set_localitati, only: %i[ show edit update destroy ]

  # GET /localitatis or /localitatis.json
  def index
    @localitatis = Localitati.all
  end

  # GET /localitatis/1 or /localitatis/1.json
  def show
  end

  # GET /localitatis/new
  def new
    @localitati = Localitati.new
  end

  # GET /localitatis/1/edit
  def edit
  end

  # POST /localitatis or /localitatis.json
  def create
    @localitati = Localitati.new(localitati_params)

    respond_to do |format|
      if @localitati.save
        format.html { redirect_to localitati_url(@localitati), notice: "Localitati was successfully created." }
        format.json { render :show, status: :created, location: @localitati }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @localitati.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /localitatis/1 or /localitatis/1.json
  def update
    respond_to do |format|
      if @localitati.update(localitati_params)
        format.html { redirect_to localitati_url(@localitati), notice: "Localitati was successfully updated." }
        format.json { render :show, status: :ok, location: @localitati }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @localitati.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /localitatis/1 or /localitatis/1.json
  def destroy
    @localitati.destroy

    respond_to do |format|
      format.html { redirect_to localitatis_url, notice: "Localitati was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  def import_judete
    xlsx = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'judete.xlsx'))

    xlsx.each_row_streaming(offset: 1, pad_cells: true) do |row|
      oasp = row[0]&.value&.to_s&.strip
      denjud = row[1]&.value&.to_s&.strip
      cod = row[2]&.value&.to_s&.strip
      idjudet = row[3]&.value&.to_i
      cod_j = row[4]&.value&.to_s&.strip

      Judet.create(oasp: oasp, denjud: denjud, cod: cod, idjudet: idjudet, cod_j: cod_j)
    end

    flash[:notice] = 'Importul județelor a fost finalizat.'
    redirect_to root_path
  end
  def import_tari
    xlsx = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'tari.xlsx'))

    xlsx.each_row_streaming(offset: 1, pad_cells: true) do |row|
      nume = row[0]&.value&.to_s&.strip
      abr = row[1]&.value&.to_s&.strip

      Tari.create(nume: nume, abr: abr)
    end

    flash[:notice] = 'Importul țărilor a fost finalizat.'
    redirect_to root_path
  end
  def import_localitati
    xlsx = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'localitati.xlsx'))

    xlsx.each_row_streaming(offset: 1, pad_cells: true) do |row|
      cod = row[0]&.value&.to_s&.strip
      judetid = row[1]&.value&.to_i
      denumire = row[2]&.value&.to_s&.strip
      denj = row[3]&.value&.to_s&.strip
      abr = row[4]&.value&.to_s&.strip
      cod_vechi = row[5]&.value&.to_s&.strip

      Localitati.create(cod: cod, judetid: judetid, denumire: denumire, denj: denj, abr: abr, cod_vechi: cod_vechi)
    end

    flash[:notice] = 'Importul localităților a fost finalizat.'
    redirect_to root_path
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_localitati
      @localitati = Localitati.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def localitati_params
      params.require(:localitati).permit(:cod, :judetid, :denumire, :denj, :abr, :cod_vechi)
    end
end
