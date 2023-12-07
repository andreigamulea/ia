class CursuriayurvedasController < ApplicationController
  before_action :set_cursuriayurveda, only: %i[ show edit update destroy ]

  # GET /cursuriayurvedas or /cursuriayurvedas.json
  def index
    @cursuriayurvedas = Cursuriayurveda.all    
  end

  # GET /cursuriayurvedas/1 or /cursuriayurvedas/1.json
  def show
  end

  # GET /cursuriayurvedas/new
  def new
    @cursuriayurveda = Cursuriayurveda.new
  end

  # GET /cursuriayurvedas/1/edit
  def edit
  end
 

  # POST /cursuriayurvedas or /cursuriayurvedas.json
  def create
    @cursuriayurveda = Cursuriayurveda.new(cursuriayurveda_params)

    respond_to do |format|
      if @cursuriayurveda.save
        format.html { redirect_to cursuriayurveda_url(@cursuriayurveda), notice: "Cursuriayurveda was successfully created." }
        format.json { render :show, status: :created, location: @cursuriayurveda }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cursuriayurveda.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cursuriayurvedas/1 or /cursuriayurvedas/1.json
  def update
    respond_to do |format|
      if @cursuriayurveda.update(cursuriayurveda_params)
        format.html { redirect_to cursuriayurveda_url(@cursuriayurveda), notice: "Cursuriayurveda was successfully updated." }
        format.json { render :show, status: :ok, location: @cursuriayurveda }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cursuriayurveda.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cursuriayurvedas/1 or /cursuriayurvedas/1.json
  def destroy
    @cursuriayurveda.destroy

    respond_to do |format|
      format.html { redirect_to cursuriayurvedas_url, notice: "Cursuriayurveda was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def cursayurveda
    @myvideo1 = Video.find_by(link: 'xGpVO2uopdc')
    @myvideo = @myvideo1.link if @myvideo1
    
    @myvideo3 = Video.where(tip: 'an1').where('ordine > ?', 1000).order(ordine: :asc)
    ##################################grupa 1
    @prodgrupa1_taxainscriere_all = Prod.find_by(cod: "cod14")
    if current_user && current_user.grupa == 1
    @titlu_pagina = 'Curs de Ayurveda - Grupa 1'
    luni = [nil, nil, "Octombrie", "Noiembrie", "Decembrie", "Ianuarie", "Februarie", "Martie", "Aprilie", "Mai", "Iunie", "Iulie", "Iulie"]
    max_taxa = ComenziProd.where(user_id: current_user.id).maximum(:taxa2324)
    
    
    @luna_curenta = luna_in_romana(Time.now.strftime("%B")) #octombrie
    @ultima_luna_platita = max_taxa.nil? ? nil : luni[max_taxa]

    


    else
      @titlu_pagina='Curs de Ayurveda'
    end
    if current_user && current_user.role==1
      max_taxa=12
    end  
    if current_user && current_user.grupa == 1
      # Verificăm dacă există o înregistrare în ComenziProd unde user_id corespunde cu current_user și taxa2324 este 1
      comanda = ComenziProd.find_by(user_id: current_user.id, taxa2324: 1)
      @textan1= 1
      # Dacă nu există astfel de înregistrare, setăm @prodgrupa1_taxainscriere
      @prodgrupa1_taxainscriere = comanda.nil? ? Prod.find_by(cod: "cod14") : nil
    else
      @prodgrupa1_taxainscriere = nil
    end
    if current_user && current_user.grupa == 1
          # Verificăm dacă există o înregistrare în ComenziProd unde user_id corespunde cu current_user și taxa2324 este 1
      exista_taxa2324_cu_1 = ComenziProd.exists?(user_id: current_user.id, taxa2324: 1)

      # Verificăm dacă există vreo înregistrare în ComenziProd unde user_id corespunde cu current_user și taxa2324 NU este 1
      exista_taxa2324_diferit_de_1 = ComenziProd.where(user_id: current_user.id).where.not(taxa2324: 1).exists?

      # Dacă există înregistrare cu taxa2324 setată ca 1 și nicio înregistrare cu valoare diferită de 1, setăm @prodgrupa1_taxaanuala
      if exista_taxa2324_cu_1 && !exista_taxa2324_diferit_de_1
        @prodgrupa1_taxaanuala = Prod.find_by(cod: "cod15")
      end

    end
    ###aici fac pentru lunile de la Octombrie la Iulie
    if current_user && current_user.grupa == 1
      valori_taxa2324 = ComenziProd.where(user_id: current_user.id).pluck(:taxa2324)
      
      # Verificăm dacă există valoarea 12
      if valori_taxa2324.include?(12)
        @prodgrupa1_taxalunara = nil
      elsif valori_taxa2324.empty? || !valori_taxa2324.include?(1)
        @prodgrupa1_taxalunara = nil
      elsif  valori_taxa2324.include?(11)
        @prodgrupa1_taxalunara = nil
      else
        # Numărăm câte valori unice avem pentru a determina produsul corespunzător
        numar_valori = valori_taxa2324.compact.max


        cod_produs = "cod#{15 + numar_valori}"  # Se adaugă 15 pentru că cod16 corespunde cu 1 valoare, cod17 cu 2 valori, etc.
        @prodgrupa1_taxalunara = Prod.find_by(cod: cod_produs)
        if current_user.email=="edvin.t.nagy@eminscubm.ro"
          @prodgrupa1_taxalunara.pret=35
        end  
      end
    
    ####################final aici fac pentru lunile de la Octombrie la Iulie

  end
##################################end grupa1
 ##########################start acces produse video an 1
 

 if max_taxa
  lunile = [nil, nil, "octombrie", "noiembrie", "decembrie", "ianuarie", "februarie", "martie", "aprilie", "mai", "iunie", "iulie", "iulie"]
  @produse_accesibile_an1 = Prod.where(curslegatura: 'an1', luna: lunile[2..(2 + max_taxa - 1)]).order(created_at: :asc)
  #ATENTIE ESTE BINE: USERUL ARE ACCES DOAR SA CUMPERE PRODUSE(VIDEO) DOAR PANA LA LUNA PE CARE A PLATIT INCLUSIV

    #start1 aici tratez situatia cand sa aiba acces la link ZOOM
    index_luna_curenta = lunile.index(@luna_curenta)


    if @ultima_luna_platita.nil?
      @are_prioritate = false
    else
      index_ultima_luna_platita = lunile.index(@ultima_luna_platita.downcase)
    puts("salut")
    puts("index_luna_curenta: #{index_luna_curenta}")
    puts("index_ultima_luna_platita: #{index_ultima_luna_platita}")
    if @luna_curenta == "august" || @luna_curenta == "septembrie"
      @are_prioritate = @ultima_luna_platita.downcase == "iulie"
      puts "1"
    elsif index_luna_curenta.nil?
      @are_prioritate = false
      puts "2"
    elsif index_luna_curenta > index_ultima_luna_platita
      @are_prioritate = false
      puts "3"
    else
      @are_prioritate = true
      puts "4"
    end
  end
    puts("Luna curenta: #{@luna_curenta}") # Exemplu: octombrie
    #puts("Ultima luna platita: #{@ultima_luna_platita.downcase}") # Exemplu: octombrie
    puts("Are prioritate: #{@are_prioritate}") # Exemplu: octombrie
    if @are_prioritate
      puts "Ultima luna platita are prioritate sau este aceeasi cu luna curenta."
    else
      puts "Luna curenta are prioritate fata de ultima luna platita."
    end
      ##stop1 aici tratez situatia cand sa aiba acces la link ZOOM

      # Obții toate codurile videourilor cu tipul 'an1'
      video_coduri = Video.where(tip: 'an1').pluck(:cod)

      # Caută în `Prods` toate id-urile care au coduri corespunzătoare cu cele ale videourilor
      prod_ids = Prod.where(cod: video_coduri).pluck(:id)

      # Obții videourile pentru care user-ul curent a plătit
      if current_user.role == 1
        @myvideo2 = Video.where(tip: 'an1').order(ordine: :asc)
      else
        @myvideo2 = Video.joins("INNER JOIN prods ON videos.cod = prods.cod")
        .joins("INNER JOIN comenzi_prods ON comenzi_prods.prod_id = prods.id")
        .where("comenzi_prods.user_id = ? AND prods.id IN (?) AND comenzi_prods.datasfarsit >= ?", current_user.id, prod_ids, Time.now)
        .where("videos.tip = 'an1'")
        .order(ordine: :asc)



      end
      
      

  else
    @produse_accesibile_an1 = []
  end



 #########################stop acces produse video an 1

  end
  def an2
    @prods=Prod.where(cod: "cod78")        
    email_eligibile = ["mihaelachazli@gmail.com", "ade.dinu@gmail.com"]   
    @has_access = current_user && (email_eligibile.include?(current_user.email) || current_user.role == 1)
    @platit = if current_user
      current_user.role == 1 || ComenziProd.where(user_id: current_user.id, validat: "Finalizata")
                 .where(prod_id: Prod.where(cod: ['cod78']).select(:id))
                 .exists?
    end
    puts("@platit= #{@platit}")
    @myvideo = Video.where(tip: 'an2').where('ordine > ? AND ordine < ?', 0, 1000).order(ordine: :asc) 
  end  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cursuriayurveda
      @cursuriayurveda = Cursuriayurveda.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cursuriayurveda_params
      params.require(:cursuriayurveda).permit(:grupa)
    end
end
