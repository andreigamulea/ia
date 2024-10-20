class CursuriayurvedasController < ApplicationController
  # Mapează codurile la numele lunilor
  CODURI_SPECIFICE_LUNI = {
    'cod207' => 'septembrie',
    'cod197' => 'octombrie',
    'cod198' => 'noiembrie',
    'cod199' => 'decembrie',
    'cod200' => 'ianuarie',
    'cod201' => 'februarie',
    'cod202' => 'martie',
    'cod203' => 'aprilie',
    'cod204' => 'mai',
    'cod205' => 'iunie',
    'cod206' => 'iulie'
  }

  # Mapare a codurilor în funcție de @max_taxa2425
  CODURI_PE_TAXA = {
    1 => ['cod207'],                    # septembrie
    2 => ['cod207', 'cod197'],           # septembrie, octombrie
    3 => ['cod207', 'cod197', 'cod198'], # septembrie, octombrie, noiembrie
    4 => ['cod207', 'cod197', 'cod198', 'cod199'], # și așa mai departe...
    5 => ['cod207', 'cod197', 'cod198', 'cod199', 'cod200'],
    6 => ['cod207', 'cod197', 'cod198', 'cod199', 'cod200', 'cod201'],
    7 => ['cod207', 'cod197', 'cod198', 'cod199', 'cod200', 'cod201', 'cod202'],
    8 => ['cod207', 'cod197', 'cod198', 'cod199', 'cod200', 'cod201', 'cod202', 'cod203'],
    9 => ['cod207', 'cod197', 'cod198', 'cod199', 'cod200', 'cod201', 'cod202', 'cod203', 'cod204'],
    10 => ['cod207', 'cod197', 'cod198', 'cod199', 'cod200', 'cod201', 'cod202', 'cod203', 'cod204', 'cod205'],
    11 => ['cod207', 'cod197', 'cod198', 'cod199', 'cod200', 'cod201', 'cod202', 'cod203', 'cod204', 'cod205', 'cod206'],
    12 => ['cod207', 'cod197', 'cod198', 'cod199', 'cod200', 'cod201', 'cod202', 'cod203', 'cod204', 'cod205', 'cod206']
  }

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
     allowed_emails = ["ce.hermkens@gmail.com","maria_mocica@yahoo.com","v_ionela@yahoo.com"]
     if current_user && (current_user.role == 1 || allowed_emails.include?(current_user.email) || ComenziProd.where(user_id: current_user.id).maximum(:taxa2324).to_i > 5) 
       
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




if (max_taxa && max_taxa > 10) || allowed_emails.include?(current_user.email)
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
      if current_user.email=="v_ionela@yahoo.com"
        @max_taxa2425=nil  #aici pun ce luna a platit sau cate luni a platit: 1 sau 2 etc 

      end  
      puts("@max_taxa2425 este: #{@max_taxa2425}")


      # Definirea array-ului cu coduri
      coduri_array = ['cod197', 'cod198', 'cod199', 'cod200', 'cod201', 'cod202', 'cod203', 'cod204', 'cod205', 'cod206']

      # Găsirea ultimei luni plătite și selectarea produselor
      if @max_taxa2425.nil?
        puts("este nil")
        @ultima_lunaPlatita2425 = "Iulie 2024"
        @prod2425 = Prod.where(cod: ['cod207', 'cod213'])
        @prod2425.each do |prod|
          if current_user.email == "nagy.edvin@yahoo.com" && prod.cod == 'cod207'
            prod.pret = 35
          elsif current_user.email == "ce.hermkens@gmail.com" && prod.cod == 'cod207'
            prod.pret = 90 #in ComenziProd la taxa2425 se pune ultima luna platita dar ATENTIE 
            #este ultima luna platita la an 2 iar userul este si la an3
            #daca implementam si an3 trebuie tinut cont de asta
          end
          
        end

        puts("Edwin Naghy are pretul1: #{@prod2425.first.pret}")
      else
        @ultima_lunaPlatita2425 = @luni2425[@max_taxa2425]
        
        # Asigură-te că indexul este valid
        cod_index = @max_taxa2425 - 1
        if cod_index >= 0 && cod_index < coduri_array.size
          @prod2425 = [Prod.find_by(cod: coduri_array[cod_index])]

          coduri_specifice = ['cod197', 'cod198', 'cod199', 'cod200', 'cod201', 'cod202', 'cod203', 'cod204', 'cod205', 'cod206']

          @prod2425.each do |prod|
            if current_user.email == "nagy.edvin@yahoo.com" && coduri_specifice.include?(prod.cod)
              prod.pret = 35
            elsif current_user.email == "ce.hermkens@gmail.com" && coduri_specifice.include?(prod.cod)
              prod.pret = 90
            end
          end


          puts("Edwin Naghy are pretul2: #{@prod2425.first.pret}")

        else
          @prod2425 = []
        end
      end

    else
      @prod2425 = []
    
    
    end  
   ################################################  an2 2024-2025 pt Video-uri
puts "Starting to retrieve videos for an2_2425"
if current_user.role == 1
  @max_taxa2425 = 12
end


puts "maxxxx= #{@max_taxa2425}"
if @max_taxa2425.nil?
  coduri_cumparate = []  # Dacă nu este setat @max_taxa2425
else
  coduri_cumparate = CODURI_PE_TAXA[@max_taxa2425] || []  # Obține codurile pentru taxa curentă
end

# Obține lunile permise pe baza codurilor cumpărate
luni_permise = coduri_cumparate.map { |cod| CODURI_SPECIFICE_LUNI[cod] }.compact
puts "Coduri cumpărate: #{coduri_cumparate}"
puts "Luni permise: #{luni_permise}"

# Asigură-te că avem luni permise înainte de interogare
if luni_permise.empty?
  puts "Nu s-au găsit luni permise pentru codurile cumpărate"
  @prods_an2_2425 = Prod.none
else
  # Găsește produsele care corespund lunilor permise
  @prods_an2_2425 = Prod.where(curslegatura: "an2_2425").where(luna: luni_permise).order(:linkstripe)
end

puts "Produse găsite: #{@prods_an2_2425.pluck(:cod)}"


if current_user.role == 1
  # Dacă utilizatorul este admin (role == 1), vede toate videourile
  @video_an2_2425 = Video.where(tip: 'an2_2425')
                         .where('ordine > ? AND ordine < ?', 0, 1000)
                         .order(ordine: :asc)
  puts "Admin user: All videos for an2_2425: #{@video_an2_2425.pluck(:cod)}"
else
  # Retrieve purchased products for the user, including validity dates
  purchased_prods = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
                               .joins(:prod)
                               .where(prods: { curslegatura: 'an2_2425' })
                               .pluck('prods.cod', 'datainceput', 'datasfarsit')
  puts "Purchased products from ComenziProd: #{purchased_prods}"

  purchased_prods1 = ComenziProd1.where(user_id: current_user.id, validat: 'Finalizata')
                                 .joins(:prod)
                                 .where(prods: { curslegatura: 'an2_2425' })
                                 .pluck('prods.cod', 'datainceput', 'datasfarsit')
  puts "Purchased products from ComenziProd1: #{purchased_prods1}"

  # If no products are purchased, initialize empty array
  purchased_prods ||= []
  purchased_prods1 ||= []

  # Combine both sets of purchased products
  all_purchased_prods = purchased_prods + purchased_prods1
  puts "All purchased products combined: #{all_purchased_prods}"

  # Select only the valid products (where datasfarsit >= Date.today)
  valid_prods = all_purchased_prods.select { |prod| prod[2] >= Date.today }
  puts "Valid products: #{valid_prods}"

  # Extract the codes of the valid products
  valid_prods_codes = valid_prods.map { |prod| prod[0] }
  puts "Valid product codes: #{valid_prods_codes}"

  # Now filter the videos by the codes of the valid products
  @video_an2_2425 = Video.where(tip: 'an2_2425')
                         .where(cod: valid_prods_codes)
                         .where('ordine > ? AND ordine < ?', 0, 1000)
                         .order(ordine: :asc)
  puts "Filtered videos for an2_2425: #{@video_an2_2425.pluck(:cod)}"
end

################################################  an2 2024-2025



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


################################################  an3 2024-2025
puts "Starting to retrieve videos for an3_2425"

@prods_an3_2425 = Prod.where(curslegatura: "an3_2425").order(:linkstripe)
puts "Prods retrieved for an3_2425: #{@prods_an3_2425.pluck(:cod)}"

if current_user.role == 1
  # Dacă utilizatorul este admin (role == 1), vede toate videourile
  @video_an3_2425 = Video.where(tip: 'an3_2425')
                         .where('ordine > ? AND ordine < ?', 0, 1000)
                         .order(ordine: :asc)
  puts "Admin user: All videos for an3_2425: #{@video_an3_2425.pluck(:cod)}"
else
  # Retrieve purchased products for the user, including validity dates
  purchased_prods = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
                               .joins(:prod)
                               .where(prods: { curslegatura: 'an3_2425' })
                               .pluck('prods.cod', 'datainceput', 'datasfarsit')
  puts "Purchased products from ComenziProd: #{purchased_prods}"

  purchased_prods1 = ComenziProd1.where(user_id: current_user.id, validat: 'Finalizata')
                                 .joins(:prod)
                                 .where(prods: { curslegatura: 'an3_2425' })
                                 .pluck('prods.cod', 'datainceput', 'datasfarsit')
  puts "Purchased products from ComenziProd1: #{purchased_prods1}"

  # If no products are purchased, initialize empty array
  purchased_prods ||= []
  purchased_prods1 ||= []

  # Combine both sets of purchased products
  all_purchased_prods = purchased_prods + purchased_prods1
  puts "All purchased products combined: #{all_purchased_prods}"

  # Select only the valid products (where datasfarsit >= Date.today)
  valid_prods = all_purchased_prods.select { |prod| prod[2] >= Date.today }
  puts "Valid products: #{valid_prods}"

  # Extract the codes of the valid products
  valid_prods_codes = valid_prods.map { |prod| prod[0] }
  puts "Valid product codes: #{valid_prods_codes}"

  # Now filter the videos by the codes of the valid products
  @video_an3_2425 = Video.where(tip: 'an3_2425')
                         .where(cod: valid_prods_codes)
                         .where('ordine > ? AND ordine < ?', 0, 1000)
                         .order(ordine: :asc)
  puts "Filtered videos for an3_2425: #{@video_an3_2425.pluck(:cod)}"
end

################################################  an3 2024-2025



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


      ################################################  an4 2024-2025
puts "Starting to retrieve videos for an4_2425"

@prods_an4_2425 = Prod.where(curslegatura: "an4_2425").order(:linkstripe)
puts "Prods retrieved for an4_2425: #{@prods_an4_2425.pluck(:cod)}"

if current_user.role == 1
  # Dacă utilizatorul este admin (role == 1), vede toate videourile
  @video_an4_2425 = Video.where(tip: 'an4_2425')
                         .where('ordine > ? AND ordine < ?', 0, 1000)
                         .order(ordine: :asc)
  puts "Admin user: All videos for an4_2425: #{@video_an4_2425.pluck(:cod)}"
else
  # Retrieve purchased products for the user, including validity dates
  purchased_prods = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
                               .joins(:prod)
                               .where(prods: { curslegatura: 'an4_2425' })
                               .pluck('prods.cod', 'datainceput', 'datasfarsit')
  puts "Purchased products from ComenziProd: #{purchased_prods}"

  purchased_prods1 = ComenziProd1.where(user_id: current_user.id, validat: 'Finalizata')
                                 .joins(:prod)
                                 .where(prods: { curslegatura: 'an4_2425' })
                                 .pluck('prods.cod', 'datainceput', 'datasfarsit')
  puts "Purchased products from ComenziProd1: #{purchased_prods1}"

  # If no products are purchased, initialize empty array
  purchased_prods ||= []
  purchased_prods1 ||= []

  # Combine both sets of purchased products
  all_purchased_prods = purchased_prods + purchased_prods1
  puts "All purchased products combined: #{all_purchased_prods}"

  # Select only the valid products (where datasfarsit >= Date.today)
  valid_prods = all_purchased_prods.select { |prod| prod[2] >= Date.today }
  puts "Valid products: #{valid_prods}"

  # Extract the codes of the valid products
  valid_prods_codes = valid_prods.map { |prod| prod[0] }
  puts "Valid product codes: #{valid_prods_codes}"

  # Now filter the videos by the codes of the valid products
  @video_an4_2425 = Video.where(tip: 'an4_2425')
                         .where(cod: valid_prods_codes)
                         .where('ordine > ? AND ordine < ?', 0, 1000)
                         .order(ordine: :asc)
  puts "Filtered videos for an4_2425: #{@video_an4_2425.pluck(:cod)}"
end

################################################  an4 2024-2025



  end  
      

  def an
    # Definim array-ul cu emailuri permise
    emailuri_permise = ["v_ionela@yahoo.com"]
  
    # Verificăm dacă utilizatorul curent este conectat și are rolul 1
    if current_user && (current_user.role == 1)
      @prod = Prod.find_by(curslegatura: 'platageneralacurs90', status: 'activ')
  
    # Verificăm dacă emailul utilizatorului curent se află în lista de emailuri permise
    elsif current_user && emailuri_permise.include?(current_user.email)
      @prod = Prod.find_by(curslegatura: 'platageneralacurs90', status: 'activ')
  
    # În caz contrar, găsim produsul cu statusul 'inactiv'
    else
      @prod = Prod.find_by(curslegatura: 'platageneralacurs', status: 'activ')
    end
  
    
  end
#########start 2024-2025

def cursayurveda2425
  @myvideo1 = Video.find_by(link: 'xGpVO2uopdc')
  @myvideo = @myvideo1.link if @myvideo1

  if current_user && (current_user.role == 1 || ComenziProd.where(user_id: current_user.id).maximum(:taxa2324).to_i > 5)
    puts("daaaaaaaaaaaaaaaaab")
  end  
  @myvideo3 = Video.where(tip: 'an1').where('ordine > ?', 1000).order(ordine: :asc)

  # Definire produse specifice
  @prodgrupa1_taxainscriere_all = Prod.find_by(cod: "cod195")
  puts("1. @prodgrupa1_taxainscriere_all arevaloarea: #{@prodgrupa1_taxainscriere_all}")

  # Verificare grupă utilizator
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

  if current_user && current_user.email == 'v_ionela@yahoo.com'
    max_taxa = nil
  end  

  # Verificare plată și alocare produse taxă grupă 1
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
      if current_user.email == "nagy.edvin@yahoo.com"
        @prodgrupa1_taxalunara.pret = 35
      elsif current_user.email == "ce.hermkens@gmail.com" || current_user.email == "mileamihaela1975@gmail.com"
        @prodgrupa1_taxalunara.pret = 90
      end
    end
  end

  # Acces produse video pentru anul 1
  if max_taxa
    lunile = [nil, nil, "octombrie", "noiembrie", "decembrie", "ianuarie", "februarie", "martie", "aprilie", "mai", "iunie", "iulie", "iulie"]
    @produse_accesibile_an1 = Prod.where(curslegatura: 'cay2425', luna: lunile[2..(2 + max_taxa - 2)]).order(created_at: :asc)

    index_luna_curenta = lunile.index(@luna_curenta)

    if @ultima_luna_platita.nil?
      @are_prioritate = false
    else
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
    end

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

  if user_signed_in?
    required_prods_sets = [['cod195', 'cod197'], ['cod195', 'cod196']] # cod196=1620 lei  cod195=60lei
    purchased_prods = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata').joins(:prod).where(prods: { curslegatura: 'cay2425', status: 'activ' }).pluck('prods.cod')
    @has_acces_zoom = (current_user.role == 1) || required_prods_sets.any? { |set| (set - purchased_prods).empty? }
  else
    @has_acces_zoom = false
  end

  if current_user
    # Coduri produse deja plătite care nu sunt expirate
    coduri_produse_platite_active = ComenziProd
                                      .where(user_id: current_user.id, validat: 'Finalizata')
                                      .joins(:prod)
                                      .where(prods: { curslegatura: 'an1_2425' })
                                      .where("comenzi_prods.datasfarsit IS NULL OR comenzi_prods.datasfarsit >= ?", Date.today)
                                      .pluck('prods.cod')
  else
    coduri_produse_platite_active = []
  end
  
  # Selectare produse care nu sunt deja plătite (sau sunt plătite dar expirate)
  if max_taxa.nil? || max_taxa == 1
    @an1_2425 = nil
  else
    lunile_accesibile = ["octombrie", "noiembrie", "decembrie", "ianuarie", "februarie", "martie", "aprilie", "mai", "iunie", "iulie"]

    # Selectăm produsele care nu au fost plătite sau sunt plătite dar expirate
    @an1_2425 = Prod.where(curslegatura: 'an1_2425', luna: lunile_accesibile[0, max_taxa - 1])
                    .where.not(cod: coduri_produse_platite_active)
                    .order(:linkstripe)
                    .to_a
  end

  if current_user
    # Determinarea videourilor cumpărate care nu sunt expirate sau expiră astăzi
    purchased_prods_video = ComenziProd
                              .where(user_id: current_user.id, validat: 'Finalizata')
                              .joins(:prod)
                              .where(prods: { curslegatura: 'an1_2425', status: 'activ' })
                              .where("comenzi_prods.datasfarsit IS NULL OR comenzi_prods.datasfarsit >= ?", Date.today)
                              .pluck('prods.cod', 'comenzi_prods.datainceput', 'comenzi_prods.datasfarsit')
  else
    purchased_prods_video = []
  end
  
  # Selectăm doar codurile produselor active (care nu sunt expirate) sau care expiră astăzi
  active_product_codes = purchased_prods_video.select do |_, _, datasfarsit|
    datasfarsit.nil? || datasfarsit.to_date >= Date.today
  end.map(&:first)
  if current_user && current_user.role == 1
    # Admin: tratează ca și cum toate produsele ar fi cumpărate, deci construim `active_product_codes` pentru toate produsele
    active_product_codes = Prod.where(curslegatura: 'an1_2425', status: 'activ').pluck(:cod)
  end
  # Selectarea videourilor corespunzătoare produselor cumpărate active și ordonarea lor după `ordine`
  @myvideo_cumparate = Video.where(cod: active_product_codes).order(:ordine)

  puts("Variabila @an1_2425 este: #{@an1_2425}")
  puts("Videouri cumpărate: #{@myvideo_cumparate}")
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
