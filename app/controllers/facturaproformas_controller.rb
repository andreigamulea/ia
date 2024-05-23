class FacturaproformasController < ApplicationController
  before_action :set_facturaproforma, only: %i[ show edit update destroy ]
  before_action :set_user_admin, only: %i[generare_facturi not_in_users]
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
  def generare_facturi
    @prod = Prod.where(cod: ['cod36', 'cod37'])
  end  
  # POST /facturaproformas/creareproforma
  #DESCRIERE metoda de mai jos: Daca userul nu are cont si este in tabela An32324 NU i se va face 
  #factura- nu se vor crea inregistrari in cele 3 tabele : Comanda, ComenziProd si Facturaproforma
  #daca in tabela An32324 pret == nil sau 0 nu se creaza inregistrari si deci nici factura
  #se creaza inregistrari in cele 3 tabele doar pt useri cu cont sa fie in An32324 cu pret>0
  #daca in An32324  la pret este trecut gr. va fi preluat cu 0 deci nu se va factura
  #AS VREA sa preaiau nume+prenume din ce pun userii pt ca acum preiau din An32324 dati de Nina (are doar nume)
  def creareproforma
    


    begin
      produs_id = params[:produs_id]
      @prod = Prod.find(produs_id)
  
      # Setăm datele în funcție de codul produsului
      case @prod.cod
      when 'cod36'
        datacomenzii = Date.new(2024, 5, 31)
      when 'cod37'
        datacomenzii = Date.new(2024, 6, 30)
      else
        raise "Codul produsului nu este recunoscut"
      end
  
      datainceput = datacomenzii
      datasfarsit = datacomenzii + @prod.valabilitatezile.to_i.days
      data_emiterii = datacomenzii
  
      An32324.find_each do |an_entry|
        user = User.find_by(email: an_entry.email)
        next unless user # Sarim daca utilizatorul nu este găsit
  
        # Verifică prețul din tabela An32324
        pret = an_entry.pret
        next if pret.nil? || pret.to_f == 0.0 # Sarim dacă prețul este nul sau 0
  
        # Verifică dacă există deja o factură proforma pentru acest user și produs
        if Facturaproforma.exists?(user_id: user.id, prod_id: produs_id)
          puts "Există deja o factură proforma pentru utilizatorul #{user.id} și produsul #{produs_id}."
          next
        end
  
        ActiveRecord::Base.transaction do
          # Creează înregistrarea în tabela Comanda
          comanda = Comanda.create!(
            datacomenzii: datacomenzii,
            statecomanda1: 'Initiata',
            statecomanda2: 'Asteptare',
            stateplata1: 'Asteptare',
            stateplata2: 'Asteptare',
            stateplata3: 'Asteptare',
            user_id: user.id,
            emailcurrent: an_entry.email,
            telefon: an_entry.telefon,
            total: pret,
            plataprin: 'Asteptare',
            prodid: @prod.id,
            prodcod: @prod.cod
          )
  
          # Actualizează numărul comenzii
          numar_comanda = Comanda.maximum(:id).to_i
          comanda.update!(numar: numar_comanda)
  
          # Creează înregistrarea în tabela ComenziProd
          ComenziProd.create!(
            comanda_id: comanda.id,
            prod_id: @prod.id,
            user_id: user.id,
            validat: "Initiata",
            datainceput: datainceput,
            datasfarsit: datasfarsit,
            cantitate: 1,
            pret_bucata: pret,
            pret_total: pret,
            obs: "fara"
          )
  
          # Găsește datele de facturare
          df = DateFacturare.find_by(email: an_entry.email)
  
          # Setează valorile implicite dacă datele de facturare nu sunt găsite
          nume = an_entry.nume
          localitate = "Bucuresti"
  
          if df
            nume_companie = df.numecompanie
            cui = df.cui
            tara = df.tara
            judet = df.judet
            strada = df.strada
            numar_adresa = df.numar
            cod_postal = df.codpostal
            altedate = df.altedate
            telefon = df.telefon
          else
            nume_companie = nil
            cui = nil
            tara = nil
            judet = nil
            strada = nil
            numar_adresa = nil
            cod_postal = nil
            altedate = nil
            telefon = an_entry.telefon
          end
  
          # Obține numărul de factură
          last_factura = Facturaproforma.maximum(:numar_factura).to_i
          numar_factura = last_factura == 0 ? 240001 : last_factura + 1
          numar_factura = numar_factura.to_s
  
          # Obține detaliile firmei
          firma = Firmeproforma.find_by(cod: 'cod1')
          raise ActiveRecord::RecordNotFound, "Firma nu a fost găsită" unless firma
  
          # Creează înregistrarea în tabela Facturaproforma
          Facturaproforma.create!(
            comanda_id: comanda.id,
            user_id: user.id,
            prod_id: @prod.id,
            numar_factura: numar_factura,
            numar_comanda: comanda.id,
            data_emiterii: data_emiterii,
            nume: nume,
            nume_companie: nume_companie,
            cui: cui,
            tara: tara,
            localitate: localitate,
            judet: judet,
            strada: strada,
            numar_adresa: numar_adresa,
            cod_postal: cod_postal,
            altedate: altedate,
            telefon: telefon,
            produs: @prod.nume,
            cantitate: 1,
            pret_unitar: pret,
            valoare_tva: firma.tva,
            valoare_totala: pret,
            cod_firma: firma.cod,
            status: "Proforma"
          )
        end
      end
  
      flash[:success] = "Facturile proforma au fost create cu succes."
      redirect_to panouadmin_path # Înlocuiește cu calea corespunzătoare
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
      puts "Eroare: #{e.message}"
      flash[:error] = "A apărut o eroare: #{e.message}"
      redirect_to root_path # Înlocuiește cu calea corespunzătoare
    end
  end

  def not_in_users #lista userilor de an 3 care nu au cont
    listacanal3_emails = Listacanal3.pluck(:email)
    user_emails = User.pluck(:email)
    date_facturare = DateFacturare.pluck(:email)

    @emails_not_in_users = listacanal3_emails - user_emails
    @emails_useri_care_nu_au_completat = listacanal3_emails - date_facturare
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
