class FacturaproformasController < ApplicationController
  before_action :set_facturaproforma, only: %i[ show edit update destroy ]

  # GET /facturaproformas or /facturaproformas.json
  def index
    @facturaproformas = Facturaproforma.all
  end

  # GET /facturaproformas/1 or /facturaproformas/1.json
  def show
  end

  # GET /facturaproformas/new
  def new
    @facturaproforma = Facturaproforma.new
  end

  # GET /facturaproformas/1/edit
  def edit
  end

  # POST /facturaproformas or /facturaproformas.json
  def create
    @facturaproforma = Facturaproforma.new(facturaproforma_params)

    respond_to do |format|
      if @facturaproforma.save
        format.html { redirect_to facturaproforma_url(@facturaproforma), notice: "Facturaproforma was successfully created." }
        format.json { render :show, status: :created, location: @facturaproforma }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @facturaproforma.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /facturaproformas/1 or /facturaproformas/1.json
  def update
    respond_to do |format|
      if @facturaproforma.update(facturaproforma_params)
        format.html { redirect_to facturaproforma_url(@facturaproforma), notice: "Facturaproforma was successfully updated." }
        format.json { render :show, status: :ok, location: @facturaproforma }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @facturaproforma.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /facturaproformas/1 or /facturaproformas/1.json
  def destroy
    @facturaproforma.destroy

    respond_to do |format|
      format.html { redirect_to facturaproformas_url, notice: "Facturaproforma was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET /facturaproformas/creareproforma
  def creareproforma
    begin
      ActiveRecord::Base.transaction do
        # Obține produsul
        puts "Căutare produs cu codul 'cod27'"
        @prod = Prod.find_by(cod: "cod27")
        raise ActiveRecord::RecordNotFound, "Produsul nu a fost găsit" unless @prod
        puts "Produs găsit: #{@prod.inspect}"

        # Găsește utilizatorul pe baza emailului
        puts "Căutare intrare în An2324"
        an_entry = An32324.first
        puts "Intrare găsită în An2324: #{an_entry.inspect}"
        puts "Căutare utilizator cu emailul: #{an_entry.email}"
        user = User.find_by(email: an_entry.email)
        raise ActiveRecord::RecordNotFound, "Utilizatorul nu a fost găsit" unless user
        puts "Utilizator găsit: #{user.inspect}"

        # Creează înregistrarea în tabela Comanda
        puts "Creare înregistrare în tabela Comanda"
        comanda = Comanda.create!(
          datacomenzii: Time.now,
          statecomanda1: 'Initiata',
          statecomanda2: 'Asteptare',
          stateplata1: 'Asteptare',
          stateplata2: 'Asteptare',
          stateplata3: 'Asteptare',
          user_id: user.id,
          emailcurrent: an_entry.email,
          telefon: an_entry.telefon,
          total: @prod.pret,
          plataprin: 'Asteptare',
          prodid: @prod.id,
          prodcod: @prod.cod
        )
        puts "Comandă creată: #{comanda.inspect}"

        # Actualizează numărul comenzii
        puts "Actualizare număr comandă"
        numar_comanda = Comanda.maximum(:id).to_i
        comanda.update!(numar: numar_comanda)
        puts "Număr comandă actualizat: #{comanda.numar}"

        # Creează înregistrarea în tabela ComenziProd
        puts "Creare înregistrare în tabela ComenziProd"
        ComenziProd.create!(
          comanda_id: comanda.id,
          prod_id: @prod.id,
          user_id: user.id,
          validat: "Initiata",
          datainceput: Time.now,
          datasfarsit: Time.now + @prod.valabilitatezile.to_i.days,
          cantitate: 1,
          pret_bucata: @prod.pret,
          pret_total: @prod.pret,
          obs: "fara"
        )
        puts "Înregistrare ComenziProd creată"

        # Găsește datele de facturare
        puts "Căutare date de facturare pentru email: #{an_entry.email}"
        df = DateFacturare.find_by(email: an_entry.email)
        raise ActiveRecord::RecordNotFound, "Datele de facturare nu au fost găsite" unless df
        puts "Date de facturare găsite: #{df.inspect}"

        # Obține numărul de factură
        puts "Obținere număr de factură"
        last_factura = Facturaproforma.maximum(:numar_factura).to_i
        if last_factura == 0
          numar_factura = 240001
        else
          numar_factura = last_factura + 1
        end
        numar_factura = numar_factura.to_s # Convertește numărul de factură în string dacă este necesar
        puts "Număr de factură: #{numar_factura}"


        # Obține detaliile firmei
        puts "Căutare firmă cu codul 'cod1'"
        firma = Firmeproforma.find_by(cod: 'cod1')
        raise ActiveRecord::RecordNotFound, "Firma nu a fost găsită" unless firma
        puts "Firmă găsită: #{firma.inspect}"

        # Creează înregistrarea în tabela Facturaproforma
        puts "Creare înregistrare în tabela Facturaproforma"
        Facturaproforma.create!(
          comanda_id: comanda.id,
          user_id: user.id,
          prod_id: @prod.id,
          numar_factura: numar_factura,
          numar_comanda: comanda.id,
          data_emiterii: Date.today,
          prenume: df.prenume,
          nume: df.nume,
          nume_companie: df.numecompanie,
          cui: df.cui,
          tara: df.tara,
          localitate: df.localitate,
          judet: df.judet,
          strada: df.strada,
          numar_adresa: df.numar,
          cod_postal: df.codpostal,
          altedate: df.altedate,
          telefon: df.telefon,
          produs: @prod.nume,
          cantitate: 1,
          pret_unitar: @prod.pret,
          valoare_tva: firma.tva,
          valoare_totala: @prod.pret,
          cod_firma: firma.cod,
          status: "Proforma"
        )
        puts "Înregistrare Facturaproforma creată"
      end

      flash[:success] = "Factura proforma a fost creată cu succes."
      redirect_to root_path # Înlocuiește cu calea corespunzătoare
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
      puts "Eroare: #{e.message}"
      flash[:error] = "A apărut o eroare: #{e.message}"
      redirect_to root_path # Înlocuiește cu calea corespunzătoare
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_facturaproforma
      @facturaproforma = Facturaproforma.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def facturaproforma_params
      params.require(:facturaproforma).permit(:comanda_id, :user_id, :prod_id, :numar_factura, :numar_comanda, :data_emiterii, :prenume, :nume, :nume_companie, :cui, :tara, :localitate, :judet, :strada, :numar_adresa, :cod_postal, :altedate, :telefon, :produs, :cantitate, :pret_unitar, :valoare_tva, :valoare_totala, :cod_firma, :status)
    end
end
