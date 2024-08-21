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
    unless user_signed_in?
      flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
      redirect_to new_user_session_path
      return false
    end
    
     if current_user && (current_user.role == 1 || ComenziProd.where(user_id: current_user.id).maximum(:taxa2324).to_i > 5) 
       
    elsif !current_user
      flash[:alert] = "Nu aveti acces la aceasta grupa de curs."
      redirect_to new_user_session_path
     else   
      redirect_to root_path
        return false
     end  
    @myvideo3 = Video.where(tip: 'an1').where('ordine > ?', 1000).order(ordine: :asc)
    puts("Ultima_luna_platita1")
    if current_user&.grupa == 1
      puts("Ultima_luna_platita2")
      @prodgrupa1_taxainscriere_all = Prod.find_by(cod: "cod14")
      @titlu_pagina = 'Curs de Ayurveda - Grupa 1'
      
      luni = [nil, nil, "Octombrie", "Noiembrie", "Decembrie", "Ianuarie", "Februarie", "Martie", "Aprilie", "Mai", "Iunie", "Iulie", "Iulie"]
      max_taxa = ComenziProd.where(user_id: current_user.id).maximum(:taxa2324)
      @luna_curenta = luna_in_romana(Time.now.strftime("%B"))
      @ultima_luna_platita = max_taxa.nil? ? nil : luni[max_taxa]
      puts("Ultima_luna_platita=#{@ultima_luna_platita}")
      @maxtaxa=max_taxa
      puts("Maxtaxa este: #{@maxtaxa}")
      comanda = ComenziProd.find_by(user_id: current_user.id, taxa2324: 1)
      @prodgrupa1_taxainscriere = comanda.nil? ? Prod.find_by(cod: "cod14") : nil
  
      if ComenziProd.exists?(user_id: current_user.id, taxa2324: 1) && !ComenziProd.where(user_id: current_user.id).where.not(taxa2324: 1).exists?
        @prodgrupa1_taxaanuala = Prod.find_by(cod: "cod15")
      end
  
      valori_taxa2324 = ComenziProd.where(user_id: current_user.id).pluck(:taxa2324)
      if valori_taxa2324.include?(12) || valori_taxa2324.empty? || !valori_taxa2324.include?(1) || valori_taxa2324.include?(11)
        @prodgrupa1_taxalunara = nil
      else
        numar_valori = valori_taxa2324.compact.max
        cod_produs = "cod#{15 + numar_valori}"
        @prodgrupa1_taxalunara = Prod.find_by(cod: cod_produs)
        @prodgrupa1_taxalunara.pret = 35 if current_user.email == "nagy.edvin@yahoo.com"
      end
    else
      @titlu_pagina = 'Curs de Ayurveda'
    end
  
    if current_user&.role == 1
      max_taxa = 12
    end
   
    if max_taxa
      lunile = [nil, nil, "octombrie", "noiembrie", "decembrie", "ianuarie", "februarie", "martie", "aprilie", "mai", "iunie", "iulie", "iulie"]
      @produse_accesibile_an1 = Prod.where(curslegatura: 'an1', luna: lunile[2..(2 + max_taxa - 2)]).order(created_at: :asc)
  
      index_luna_curenta = lunile.index(@luna_curenta)
      if @ultima_luna_platita
        index_ultima_luna_platita = lunile.index(@ultima_luna_platita.downcase)
        if @luna_curenta == "august" || @luna_curenta == "septembrie"
          @are_prioritate = @ultima_luna_platita.downcase == "iulie"
        elsif index_luna_curenta.nil?
          @are_prioritate = false
        elsif index_luna_curenta > index_ultima_luna_platita
          @are_prioritate = false
        else
          @are_prioritate = true
        end
      else
        @are_prioritate = false
      end
  
      video_coduri = Video.where(tip: 'an1').pluck(:cod)
      prod_ids = Prod.where(cod: video_coduri).pluck(:id)
  
      @myvideo2 = if current_user.role == 1
                    Video.where(tip: 'an1').where("ordine < 1000").order(ordine: :asc)
                  else
                    Video.joins("INNER JOIN prods ON videos.cod = prods.cod")
                         .joins("INNER JOIN comenzi_prods ON comenzi_prods.prod_id = prods.id")
                         .where("comenzi_prods.user_id = ? AND prods.id IN (?) AND comenzi_prods.datasfarsit >= ?", current_user.id, prod_ids, Time.now)
                         .where("videos.tip = 'an1' AND videos.ordine < 1000")
                         .order(ordine: :asc)
                  end
    else
      @produse_accesibile_an1 = []
    end
############################################incep sa folosesc datele de la an1 2324 la an2 2425


    if max_taxa>10 
      @promovat_in_an2 = true
      puts("a promovat")
    else
      @promovat_in_an2 = false
      puts("NU a promovat")
    end    
    if @promovat_in_an2
      puts("A promovat")
      # Definirea lunilor și valoarea maximă a taxei
      @luni2425 = [nil, "Septembrie", "Octombrie", "Noiembrie", "Decembrie", "Ianuarie", "Februarie", "Martie", "Aprilie", "Mai", "Iunie", "Iulie", "Iulie"]
      @max_taxa2425 = ComenziProd.where(user_id: current_user.id).where.not(prod_id: 198).maximum(:taxa2425)

      # Definirea array-ului cu coduri
      coduri_array = ['cod197', 'cod198', 'cod199', 'cod200', 'cod201', 'cod202', 'cod203', 'cod204', 'cod205', 'cod206']

      # Găsirea ultimei luni plătite și selectarea produselor
      if @max_taxa2425.nil?
        puts("este nil")
        @ultima_lunaPlatita2425 = "Iulie 2024"
        @prod2425 = Prod.where(cod: ['cod207', 'cod213'])
        
      else
        @ultima_lunaPlatita2425 = @luni2425[@max_taxa2425]
        # Asigură-te că indexul este valid
        cod_index = @max_taxa2425 - 1
        if cod_index >= 0 && cod_index < coduri_array.size
          @prod2425 = [Prod.find_by(cod: coduri_array[cod_index])]
        else
          @prod2425 = []
        end
      end


    
    
    end  


  end
  
  def an2 #2023-24
    lunile = ["septembrie", "octombrie", "noiembrie", "decembrie", "ianuarie", "februarie", "martie", "aprilie", "mai", "iunie", "iulie"]
    inregistrari_valide = Listacanal2.where(platit: lunile)
  
    unless current_user.role == 1 || inregistrari_valide.exists?(email: current_user.email)
      redirect_to root_path and return
    end
  
    inregistrare_user = Listacanal2.find_by(email: current_user.email)
    luna_curenta_romana = luna_in_romana(Time.current.in_time_zone('Europe/Bucharest').strftime("%B"))
    index_luna_curenta = lunile.index(luna_curenta_romana)
    if current_user.role!=1
      index_luna_platit = lunile.index(inregistrare_user.platit)
      puts("Ultima luna platita: #{index_luna_platit}")
    end
    produse_platite_ids = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
                                       .where('datasfarsit IS NULL OR datasfarsit >= ?', Date.current)
                                       .pluck(:prod_id)
  
    # Selectează doar produsele până la luna plătită
    if current_user.role==1
      @prods = Prod.where(curslegatura: "an2").order(:linkstripe)
    else  
     # Prelucrarea inițială pentru a determina produsele valide
      produse_valide_ids = Prod.where(curslegatura: "an2")
      .where.not(id: produse_platite_ids)
      .select { |prod| lunile.index(prod.luna) <= index_luna_platit }
      .map(&:id)

      # Utilizarea ID-urilor produselor valide pentru a face o interogare ordonată
      @prods = Prod.where(id: produse_valide_ids).order(:linkstripe)

  
    end  


    #email_eligibile = ["mihaelachazli@gmail.com", "ade.dinu@gmail.com", "arkosi.mariann@gmail.com","ce.hermkens@gmail.com","tatiana_aldescu@yahoo.com"]   

   
        
        coduri_produse_platite = ComenziProd.joins(:prod)
                                          .where(user_id: current_user.id, validat: 'Finalizata')
                                          .where('datasfarsit IS NULL OR datasfarsit >= ?', Date.current)
                                          .pluck('prods.cod')

        # Obține toate videoclipurile care au un cod corespunzător produselor plătite
        if current_user.role==1
          @myvideo = Video.where(tip: 'an2')
                        .where('ordine > ? AND ordine < ?', 0, 1000)
                        .order(ordine: :asc)
        else  
        @myvideo = Video.where(tip: 'an2')
                        .where('ordine > ? AND ordine < ?', 0, 1000)
                        .where(cod: coduri_produse_platite)
                        .order(ordine: :asc) 
        end  
        @platit = if current_user
          current_user.role == 1 || coduri_produse_platite.count > 0
        end
    
        puts("@platit= #{@platit}")
    


        @prod = Prod.find_by(curslegatura: 'platageneralacurs', status: 'activ')
    end  



    def an3 #2023-24
      lunile = ["septembrie", "octombrie", "noiembrie", "decembrie", "ianuarie", "februarie", "martie", "aprilie", "mai", "iunie", "iulie"]
      inregistrari_valide = Listacanal3.where(platit: lunile)
    
      unless current_user.role == 1 || inregistrari_valide.exists?(email: current_user.email)
        redirect_to root_path and return
      end
    
      inregistrare_user = Listacanal3.find_by(email: current_user.email)
      luna_curenta_romana = luna_in_romana(Time.current.in_time_zone('Europe/Bucharest').strftime("%B"))
      index_luna_curenta = lunile.index(luna_curenta_romana)
      if current_user.role!=1
        index_luna_platit = lunile.index(inregistrare_user.platit)
        puts("Ultima luna platita: #{index_luna_platit}")
      end
      produse_platite_ids = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
                                         .where('datasfarsit IS NULL OR datasfarsit >= ?', Date.current)
                                         .pluck(:prod_id)
    
      # Selectează doar produsele până la luna plătită
      if current_user.role==1
        @prods = Prod.where(curslegatura: "an3").order(:linkstripe)
      else  
       # Prelucrarea inițială pentru a determina produsele valide
        produse_valide_ids = Prod.where(curslegatura: "an3")
        .where.not(id: produse_platite_ids)
        .select { |prod| lunile.index(prod.luna) <= index_luna_platit }
        .map(&:id)
  
        # Utilizarea ID-urilor produselor valide pentru a face o interogare ordonată
        @prods = Prod.where(id: produse_valide_ids).order(:linkstripe)
  
    
      end  
  
  
      #email_eligibile = ["mihaelachazli@gmail.com", "ade.dinu@gmail.com", "arkosi.mariann@gmail.com","ce.hermkens@gmail.com","tatiana_aldescu@yahoo.com"]   
  
     
          
          coduri_produse_platite = ComenziProd.joins(:prod)
                                            .where(user_id: current_user.id, validat: 'Finalizata')
                                            .where('datasfarsit IS NULL OR datasfarsit >= ?', Date.current)
                                            .pluck('prods.cod')
  
          # Obține toate videoclipurile care au un cod corespunzător produselor plătite
          if current_user.role==1
            @myvideo = Video.where(tip: 'an3')
                          .where('ordine > ? AND ordine < ?', 0, 1000)
                          .order(ordine: :asc)
          else  
          @myvideo = Video.where(tip: 'an3')
                          .where('ordine > ? AND ordine < ?', 0, 1000)
                          .where(cod: coduri_produse_platite)
                          .order(ordine: :asc) 
          end  
          @platit = if current_user
            current_user.role == 1 || coduri_produse_platite.count > 0
          end
      
          puts("@platit= #{@platit}")
      
  
  
          @prod = Prod.find_by(curslegatura: 'platageneralacurs', status: 'activ')
      end  


def an
  @prod = Prod.find_by(curslegatura: 'platageneralacurs', status: 'activ')
end  
#########start 2024-2025

def cursayurveda2425
  @myvideo1 = Video.find_by(link: 'xGpVO2uopdc')
  @myvideo = @myvideo1.link if @myvideo1

  if current_user && (current_user.role == 1 || ComenziProd.where(user_id: current_user.id).maximum(:taxa2324).to_i > 5)
    puts("daaaaaaaaaaaaaaaaab")
  end  
  @myvideo3 = Video.where(tip: 'an1').where('ordine > ?', 1000).order(ordine: :asc)
  ##################################grupa 1
  @prodgrupa1_taxainscriere_all = Prod.find_by(cod: "cod195")
  puts("1. @prodgrupa1_taxainscriere_all arevaloarea: #{@prodgrupa1_taxainscriere_all}")
  if current_user && current_user.grupa2425 == 1
    @titlu_pagina = 'Curs de Ayurveda - Grupa 1'
    luni = [nil, nil, "Octombrie", "Noiembrie", "Decembrie", "Ianuarie", "Februarie", "Martie", "Aprilie", "Mai", "Iunie", "Iulie", "Iulie"]
    max_taxa = ComenziProd.where(user_id: current_user.id).maximum(:taxa2425)
    puts("maxtaxa este: #{max_taxa}")
    @luna_curenta = luna_in_romana(Time.now.strftime("%B")) #octombrie
    @ultima_luna_platita = max_taxa.nil? ? nil : luni[max_taxa]

  else
    @titlu_pagina = 'Curs de Ayurveda'
  end

  if current_user && current_user.role == 1
    max_taxa = 12
  end

  if current_user && current_user.grupa2425 == 1
    comanda = ComenziProd.find_by(user_id: current_user.id, taxa2425: 1)
    @textan1 = 1
    @prodgrupa1_taxainscriere = comanda.nil? ? Prod.find_by(cod: "cod195") : nil
  else
    @prodgrupa1_taxainscriere = nil
  end

  if current_user && current_user.grupa2425 == 1
    exista_taxa2425_cu_1 = ComenziProd.exists?(user_id: current_user.id, taxa2425: 1)
    exista_taxa2425_diferit_de_1 = ComenziProd.where(user_id: current_user.id).where.not(taxa2425: 1).exists?

    if exista_taxa2425_cu_1 && !exista_taxa2425_diferit_de_1
      @prodgrupa1_taxaanuala = Prod.find_by(cod: "cod196")
    end
  end

  if current_user && current_user.grupa2425 == 1
    valori_taxa2425 = ComenziProd.where(user_id: current_user.id).pluck(:taxa2425).compact
    
    if valori_taxa2425.include?(12)
      @prodgrupa1_taxalunara = nil
    elsif valori_taxa2425.empty? || !valori_taxa2425.include?(1)
      @prodgrupa1_taxalunara = nil
    elsif valori_taxa2425.include?(11)
      @prodgrupa1_taxalunara = nil
    else
      numar_valori = valori_taxa2425.count { |val| val > 1 && val < 12 }
      cod_produs = "cod#{196 + numar_valori + 1}"
      @prodgrupa1_taxalunara = Prod.find_by(cod: cod_produs)
      if current_user.email == "nagy.edvin@yahoo.com" #custom
        @prodgrupa1_taxalunara.pret = 35
      end
    end
  end
  ##################################end grupa1
  ##########################start acces produse video an 1

  if max_taxa
    lunile = [nil, nil, "octombrie", "noiembrie", "decembrie", "ianuarie", "februarie", "martie", "aprilie", "mai", "iunie", "iulie", "iulie"]
    @produse_accesibile_an1 = Prod.where(curslegatura: 'cay2425', luna: lunile[2..(2 + max_taxa - 2)]).order(created_at: :asc)
    ##start1 aici tratez situatia cand sa aiba acces la link ZOOM
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
    puts("Luna curenta: #{@luna_curenta}")
    puts("Are prioritate: #{@are_prioritate}")
    if @are_prioritate
      puts "Ultima luna platita are prioritate sau este aceeasi cu luna curenta."
    else
      puts "Luna curenta are prioritate fata de ultima luna platita."
    end
    ##stop1 aici tratez situatia cand sa aiba acces la link ZOOM

    video_coduri = Video.where(tip: 'cay2425').pluck(:cod)
    prod_ids = Prod.where(cod: video_coduri).pluck(:id)

    if current_user.role == 1
      @myvideo2 = Video.where(tip: 'cay2425').order(ordine: :asc)
    else
      @myvideo2 = Video.joins("INNER JOIN prods ON videos.cod = prods.cod")
                       .joins("INNER JOIN comenzi_prods ON comenzi_prods.prod_id = prods.id")
                       .where("comenzi_prods.user_id = ? AND prods.id IN (?) AND comenzi_prods.datasfarsit >= ?", current_user.id, prod_ids, Time.now)
                       .where("videos.tip = 'cay2425'")
                       .order(ordine: :asc)
    end
  else
    @produse_accesibile_an1 = []
  end
  ##########################stop acces produse video an 1
end






############end 2024-2025
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
