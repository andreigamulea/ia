class TvsController < ApplicationController
  before_action :set_tv, only: %i[ show edit update destroy ]

  # GET /tvs or /tvs.json

  def canal1
    @has_access = false
    if current_user && (Listacanal1.exists?(email: current_user.email) || current_user.role == 1)
      @has_access = true
    end
    now_bucharest = Time.current.in_time_zone('Europe/Bucharest')
    @now_bucharest = now_bucharest
    data_curenta = @now_bucharest.to_date
    # Colectează toate 'orainceput' pentru înregistrările din data curentă
    #@orare_inceput_azi = Tv.where(datainceput: data_curenta).pluck(:orainceput, :orasfarsit)
    @orare_inceput_sfarsit_azi = Tv.where(datainceput: data_curenta, canal: 1).pluck(:orainceput, :orasfarsit).flat_map { |orainceput, orasfarsit| [orainceput, orasfarsit] }.uniq

   
    # Convertim fiecare ora de inceput in format HH:MM pentru a facilita comparatia in JavaScript
    @orare_inceput_sfarsit_azi = @orare_inceput_sfarsit_azi.map { |ora| ora.strftime('%H:%M') }

    @myvideo1 = Tv.where(canal: 1)
              .where("datainceput <= ? AND datasfarsit >= ?", now_bucharest.to_date, now_bucharest.to_date)
              .to_a
              .detect do |tv|
                # Ajustăm orainceput la data curentă
                ora_inceput_ajustata = tv.orainceput.change(year: now_bucharest.year, month: now_bucharest.month, day: now_bucharest.day, zone: 'Europe/Bucharest')
                
                # Dacă datasfarsit este aceeași zi cu datainceput, ajustăm orasfarsit la aceeași zi
                if tv.datasfarsit == tv.datainceput
                  ora_sfarsit_ajustata = tv.orasfarsit.change(year: now_bucharest.year, month: now_bucharest.month, day: now_bucharest.day, zone: 'Europe/Bucharest')
                else
                  # Dacă datasfarsit este diferită, ajustăm orasfarsit la datasfarsit
                  ora_sfarsit_ajustata = tv.orasfarsit.change(year: tv.datasfarsit.year, month: tv.datasfarsit.month, day: tv.datasfarsit.day, zone: 'Europe/Bucharest')
                end

                # Comparam acum cu orele ajustate
                result = now_bucharest >= ora_inceput_ajustata && now_bucharest <= ora_sfarsit_ajustata
                puts "Comparând: Acum - #{now_bucharest}, Început ajustat - #{ora_inceput_ajustata}, Sfârșit ajustat - #{ora_sfarsit_ajustata}. Rezultat: #{result}"
                
                result
              end

      puts "Video selectat: #{@myvideo1 ? @myvideo1.id : 'Niciunul'}"
      # Setează variabilele în funcție de rezultatul interogării
      if @myvideo1
        @myvideo = @myvideo1.link
        @exista_video = true
        @denumire = @myvideo1.denumire      
        @data_sfarsit = @myvideo1.datasfarsit.strftime("%d.%m.%Y") if @myvideo1&.datasfarsit

        @valabilitate_ora_sfarsit = @myvideo1.orasfarsit.strftime("%H:%M") if @myvideo1.orasfarsit      
        
      else
        @myvideo1 = nil
        @exista_video = false
      end

  end
  def canal2
    lunile = ["septembrie", "octombrie", "noiembrie", "decembrie", "ianuarie", "februarie", "martie", "aprilie", "mai", "iunie", "iulie","august"]
  
    # Utilizatorii cu role == 1 au acces automat
    unless current_user.role == 1
      inregistrare_user = Listacanal2.find_by(email: current_user.email)
  
      # Dacă nu există înregistrare pentru user și nu are rolul 1, redirecționează
      if inregistrare_user.nil?
        redirect_to root_path and return
      end
  
      # Verifică dacă valoarea lui 'platit' este "nimic" pentru utilizatorii care nu sunt rolul 1
      if inregistrare_user.platit == "nimic"
        redirect_to root_path and return
      end
  
      # Găsește indexul lunii 'platit' din înregistrarea userului și determină luna curentă în română
      luna_curenta_romana = luna_in_romana(Time.current.in_time_zone('Europe/Bucharest').strftime("%B"))
      index_luna_curenta = lunile.index(luna_curenta_romana)
      index_luna_platit = lunile.index(inregistrare_user.platit)
      
      # Calculăm indexul lunii anterioare
      index_luna_anterioara = (index_luna_curenta - 1) % lunile.length
      
      puts("luna_curenta_romana: #{luna_curenta_romana}")
      puts("index_luna_curenta: #{index_luna_curenta}")
      puts("index_luna_platit: #{index_luna_platit}")
      puts("index_luna_anterioara: #{index_luna_anterioara}")
  
      # Dacă luna 'platit' este mai mică decât luna curentă și luna anterioară, redirect către root_path
      if index_luna_platit.nil? || index_luna_curenta.nil? || (index_luna_platit < index_luna_curenta && index_luna_platit < index_luna_anterioara)
        redirect_to root_path and return
      end
    end
  
    now_bucharest = Time.current.in_time_zone('Europe/Bucharest')
    @now_bucharest = now_bucharest
    data_curenta = @now_bucharest.to_date
    @orare_inceput_sfarsit_azi = Tv.where(datainceput: data_curenta, canal: 2).pluck(:orainceput, :orasfarsit).flat_map { |orainceput, orasfarsit| [orainceput, orasfarsit] }.uniq
  
    # Convertim fiecare ora de inceput in format HH:MM pentru a facilita comparatia in JavaScript
    @orare_inceput_sfarsit_azi = @orare_inceput_sfarsit_azi.map { |ora| ora.strftime('%H:%M') }
  
    @myvideo1 = Tv.where(canal: 2)
                  .where("datainceput <= ? AND datasfarsit >= ?", now_bucharest.to_date, now_bucharest.to_date)
                  .to_a
                  .detect do |tv|
                    # Ajustăm orainceput la data curentă
                    ora_inceput_ajustata = tv.orainceput.change(year: now_bucharest.year, month: now_bucharest.month, day: now_bucharest.day, zone: 'Europe/Bucharest')
  
                    # Dacă datasfarsit este aceeași zi cu datainceput, ajustăm orasfarsit la aceeași zi
                    if tv.datasfarsit == tv.datainceput
                      ora_sfarsit_ajustata = tv.orasfarsit.change(year: now_bucharest.year, month: now_bucharest.month, day: now_bucharest.day, zone: 'Europe/Bucharest')
                    else
                      # Dacă datasfarsit este diferită, ajustăm orasfarsit la datasfarsit
                      ora_sfarsit_ajustata = tv.orasfarsit.change(year: tv.datasfarsit.year, month: tv.datasfarsit.month, day: tv.datasfarsit.day, zone: 'Europe/Bucharest')
                    end
  
                    # Comparam acum cu orele ajustate
                    result = now_bucharest >= ora_inceput_ajustata && now_bucharest <= ora_sfarsit_ajustata
                    puts "Comparând: Acum - #{now_bucharest}, Început ajustat - #{ora_inceput_ajustata}, Sfârșit ajustat - #{ora_sfarsit_ajustata}. Rezultat: #{result}"
  
                    result
                  end
  
    puts "Video selectat: #{@myvideo1 ? @myvideo1.id : 'Niciunul'}"
    # Setează variabilele în funcție de rezultatul interogării
    if @myvideo1
      @myvideo = @myvideo1.link
      @exista_video = true
      @denumire = @myvideo1.denumire
      @data_inceput = @myvideo1.datainceput.strftime("%d.%m.%Y") if @myvideo1&.datainceput
      @data_sfarsit = @myvideo1.datasfarsit.strftime("%d.%m.%Y") if @myvideo1&.datasfarsit
      @ora_inceput = @myvideo1.orainceput if @myvideo1&.orainceput
      @valabilitate_ora_inceput = @myvideo1.orainceput.strftime("%H:%M") if @myvideo1.orainceput
      @valabilitate_ora_sfarsit = @myvideo1.orasfarsit.strftime("%H:%M") if @myvideo1.orasfarsit
    else
      @myvideo1 = nil
      @exista_video = false
    end
  end
  
  
  def canal3
    lunile = ["septembrie", "octombrie", "noiembrie", "decembrie", "ianuarie", "februarie", "martie", "aprilie", "mai", "iunie", "iulie","august"]
  
    # Utilizatorii cu role == 1 au acces automat
    unless current_user.role == 1
      inregistrare_user = Listacanal3.find_by(email: current_user.email)
  
      # Dacă nu există înregistrare pentru user și nu are rolul 1, redirecționează
      if inregistrare_user.nil?
        redirect_to root_path and return
      end
  
      # Verifică dacă valoarea lui 'platit' este "nimic" pentru utilizatorii care nu sunt rolul 1
      if inregistrare_user.platit == "nimic"
        redirect_to root_path and return
      end
  
      # Găsește indexul lunii 'platit' din înregistrarea userului și determină luna curentă în română
      luna_curenta_romana = luna_in_romana(Time.current.in_time_zone('Europe/Bucharest').strftime("%B"))
      index_luna_curenta = lunile.index(luna_curenta_romana)
      index_luna_platit = lunile.index(inregistrare_user.platit)
      
      # Calculăm indexul lunii anterioare
      index_luna_anterioara = (index_luna_curenta - 1) % lunile.length
      
      puts("luna_curenta_romana: #{luna_curenta_romana}")
      puts("index_luna_curenta: #{index_luna_curenta}")
      puts("index_luna_platit: #{index_luna_platit}")
      puts("index_luna_anterioara: #{index_luna_anterioara}")
  
      # Dacă luna 'platit' este mai mică decât luna curentă și luna anterioară, redirect către root_path
      if index_luna_platit.nil? || index_luna_curenta.nil? || (index_luna_platit < index_luna_curenta && index_luna_platit < index_luna_anterioara)
        redirect_to root_path and return
      end
    end
  
    now_bucharest = Time.current.in_time_zone('Europe/Bucharest')
    @now_bucharest = now_bucharest
    data_curenta = @now_bucharest.to_date
    @orare_inceput_sfarsit_azi = Tv.where(datainceput: data_curenta, canal: 3).pluck(:orainceput, :orasfarsit).flat_map { |orainceput, orasfarsit| [orainceput, orasfarsit] }.uniq
  
    # Convertim fiecare ora de inceput in format HH:MM pentru a facilita comparatia in JavaScript
    @orare_inceput_sfarsit_azi = @orare_inceput_sfarsit_azi.map { |ora| ora.strftime('%H:%M') }
  
    @myvideo1 = Tv.where(canal: 3)
                  .where("datainceput <= ? AND datasfarsit >= ?", now_bucharest.to_date, now_bucharest.to_date)
                  .to_a
                  .detect do |tv|
                    # Ajustăm orainceput la data curentă
                    ora_inceput_ajustata = tv.orainceput.change(year: now_bucharest.year, month: now_bucharest.month, day: now_bucharest.day, zone: 'Europe/Bucharest')
  
                    # Dacă datasfarsit este aceeași zi cu datainceput, ajustăm orasfarsit la aceeași zi
                    if tv.datasfarsit == tv.datainceput
                      ora_sfarsit_ajustata = tv.orasfarsit.change(year: now_bucharest.year, month: now_bucharest.month, day: now_bucharest.day, zone: 'Europe/Bucharest')
                    else
                      # Dacă datasfarsit este diferită, ajustăm orasfarsit la datasfarsit
                      ora_sfarsit_ajustata = tv.orasfarsit.change(year: tv.datasfarsit.year, month: tv.datasfarsit.month, day: tv.datasfarsit.day, zone: 'Europe/Bucharest')
                    end
  
                    # Comparam acum cu orele ajustate
                    result = now_bucharest >= ora_inceput_ajustata && now_bucharest <= ora_sfarsit_ajustata
                    puts "Comparând: Acum - #{now_bucharest}, Început ajustat - #{ora_inceput_ajustata}, Sfârșit ajustat - #{ora_sfarsit_ajustata}. Rezultat: #{result}"
  
                    result
                  end
  
    puts "Video selectat: #{@myvideo1 ? @myvideo1.id : 'Niciunul'}"
    ## Setează variabilele în funcție de rezultatul interogării
    if @myvideo1
      @myvideo = @myvideo1.link
      @exista_video = true
      @denumire = @myvideo1.denumire
      @data_sfarsit = @myvideo1.datasfarsit.strftime("%d.%m.%Y") if @myvideo1&.datasfarsit
      @valabilitate_ora_sfarsit = @myvideo1.orasfarsit.strftime("%H:%M") if @myvideo1.orasfarsit
    else
      @myvideo1 = nil
      @exista_video = false
    end
  end
  




  def seminarii
   
    now_bucharest = Time.current.in_time_zone('Europe/Bucharest')
    @now_bucharest = now_bucharest
    data_curenta = @now_bucharest.to_date
    # Colectează toate 'orainceput' pentru înregistrările din data curentă
    #@orare_inceput_azi = Tv.where(datainceput: data_curenta).pluck(:orainceput, :orasfarsit)
    @orare_inceput_sfarsit_azi = Tv.where(datainceput: data_curenta, canal: 4).pluck(:orainceput, :orasfarsit).flat_map { |orainceput, orasfarsit| [orainceput, orasfarsit] }.uniq

   
    # Convertim fiecare ora de inceput in format HH:MM pentru a facilita comparatia in JavaScript
    @orare_inceput_sfarsit_azi = @orare_inceput_sfarsit_azi.map { |ora| ora.strftime('%H:%M') }
    

    @myvideo1 = Tv.where(canal: 4)
              .where("datainceput <= ? AND datasfarsit >= ?", now_bucharest.to_date, now_bucharest.to_date)
              .to_a
              .detect do |tv|
                # Ajustăm orainceput la data curentă
                ora_inceput_ajustata = tv.orainceput.change(year: now_bucharest.year, month: now_bucharest.month, day: now_bucharest.day, zone: 'Europe/Bucharest')
                
                # Dacă datasfarsit este aceeași zi cu datainceput, ajustăm orasfarsit la aceeași zi
                if tv.datasfarsit == tv.datainceput
                  ora_sfarsit_ajustata = tv.orasfarsit.change(year: now_bucharest.year, month: now_bucharest.month, day: now_bucharest.day, zone: 'Europe/Bucharest')
                else
                  # Dacă datasfarsit este diferită, ajustăm orasfarsit la datasfarsit
                  ora_sfarsit_ajustata = tv.orasfarsit.change(year: tv.datasfarsit.year, month: tv.datasfarsit.month, day: tv.datasfarsit.day, zone: 'Europe/Bucharest')
                end

                # Comparam acum cu orele ajustate
                result = now_bucharest >= ora_inceput_ajustata && now_bucharest <= ora_sfarsit_ajustata
                puts "Comparând: Acum - #{now_bucharest}, Început ajustat - #{ora_inceput_ajustata}, Sfârșit ajustat - #{ora_sfarsit_ajustata}. Rezultat: #{result}"
                
                result
              end

      puts "Video selectat: #{@myvideo1 ? @myvideo1.id : 'Niciunul'}"
      # Setează variabilele în funcție de rezultatul interogării
      if @myvideo1
        @myvideo = @myvideo1.link
        @exista_video = true
        @denumire = @myvideo1.denumire      
        @data_inceput = @myvideo1.datainceput.strftime("%d.%m.%Y") if @myvideo1&.datainceput
        @data_sfarsit = @myvideo1.datasfarsit.strftime("%d.%m.%Y") if @myvideo1&.datasfarsit
        @ora_inceput = @myvideo1.orainceput if @myvideo1&.orainceput
        @valabilitate_ora_inceput = @myvideo1.orainceput.strftime("%H:%M") if @myvideo1.orainceput  
        @valabilitate_ora_sfarsit = @myvideo1.orasfarsit.strftime("%H:%M") if @myvideo1.orasfarsit   
        
      else
        @myvideo1 = nil
        @exista_video = false
      end

  end
  








  def listacanal1
    unless current_user&.role == 1
      redirect_to root_path, alert: "Acces restricționat!" and return
    end
    xlsx = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'listacanal1.xlsx'))
    emailuri_importate = 0
  
    # Golește tabela Listacanal1 înainte de import
    Listacanal1.destroy_all
  
    xlsx.each_row_streaming(offset: 1, pad_cells: true) do |row| # Presupunem că prima rând are anteturi
      email = row[0]&.value&.strip&.downcase
      next unless email
  
      # Creează o înregistrare în Listacanal1 pentru fiecare email
      Listacanal1.create!(email: email)
      emailuri_importate += 1
    end
  
    # Afișează un mesaj cu numărul de emailuri importate
    if emailuri_importate > 0
      flash[:notice] = "#{emailuri_importate} adrese de email au fost importate cu succes în listacanal1."
    else
      flash[:alert] = "Niciun email nou nu a fost adăugat în listacanal1."
    end
  
    # Redirecționează la o pagină după finalizarea importului, de exemplu înapoi la index
    redirect_to panouadmin_path
  end

  def listacanal2 #atentie ; este facut si un controler listacanal2 pt CRUD
    unless current_user&.role == 1
      redirect_to root_path, alert: "Acces restricționat!" and return
    end
    xlsx = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'listacanal2.xlsx'))
    emailuri_importate = 0
  
    # Golește tabela Listacanal2 înainte de import
    Listacanal2.destroy_all
  
    xlsx.each_row_streaming(offset: 1, pad_cells: true) do |row| # Presupunem că prima rând are anteturi
      email = row[0]&.value&.strip&.downcase
      next unless email
  
      # Crează un array cu valorile de la row[3] până la row[13], inclusiv nil unde nu există valori
      valori_array = (3..13).map { |i| row[i]&.value }
  
      # Afișează valorile obținute în consolă
      puts "Valorile obținute sunt: #{valori_array}"
  
      # Găsește indexul ultimului element din array care nu este nil
      index_ultim_element_non_nil = valori_array.each_with_index.reject { |val, _| val.nil? }.last&.last
  
      lunile = ["septembrie", "octombrie", "noiembrie", "decembrie", "ianuarie", "februarie", "martie", "aprilie", "mai", "iunie", "iulie"]
  
      # Determină luna corespunzătoare ultimului element non-nil, dacă există
      luna_corespunzatoare = nil
      if index_ultim_element_non_nil && index_ultim_element_non_nil.between?(0, 10)
        luna_corespunzatoare = lunile[index_ultim_element_non_nil]
        puts "Ultima lună care nu este nil este: #{luna_corespunzatoare}"
      else
        puts "Nu s-a găsit o valoare non-nil în intervalul specificat."
        luna_corespunzatoare = "nimic"
      end
  
      # Creează o înregistrare în Listacanal2 pentru fiecare email, inclusiv luna corespunzătoare, dacă este disponibilă
      Listacanal2.create!(email: email, platit: luna_corespunzatoare)
  
      emailuri_importate += 1
    end
  
    # Afișează un mesaj cu numărul de emailuri importate
    if emailuri_importate > 0
      flash[:notice] = "#{emailuri_importate} adrese de email au fost importate cu succes în listacanal2."
    else
      flash[:alert] = "Niciun email nou nu a fost adăugat în listacanal2."
    end
  
    # Redirecționează la o pagină după finalizarea importului, de exemplu înapoi la index
    redirect_to panouadmin_path
  end
  
  
  
  
  def listacanal3
    unless current_user&.role == 1
      redirect_to root_path, alert: "Acces restricționat!" and return
    end
    xlsx = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'listacanal3.xlsx'))
    emailuri_importate = 0
  
    # Golește tabela Listacanal3 înainte de import
    Listacanal3.destroy_all
  
    xlsx.each_row_streaming(offset: 1, pad_cells: true) do |row| # Presupunem că prima rând are anteturi
      email = row[0]&.value&.strip&.downcase
      next unless email
  
      # Crează un array cu valorile de la row[3] până la row[13], inclusiv nil unde nu există valori
      valori_array = (3..13).map { |i| row[i]&.value }
  
      # Afișează valorile obținute în consolă
      puts "Valorile obținute sunt: #{valori_array}"
  
      # Găsește indexul ultimului element din array care nu este nil
      index_ultim_element_non_nil = valori_array.each_with_index.reject { |val, _| val.nil? }.last&.last
  
      lunile = ["septembrie", "octombrie", "noiembrie", "decembrie", "ianuarie", "februarie", "martie", "aprilie", "mai", "iunie", "iulie"]
  
      # Determină luna corespunzătoare ultimului element non-nil, dacă există
      luna_corespunzatoare = nil
      if index_ultim_element_non_nil && index_ultim_element_non_nil.between?(0, 10)
        luna_corespunzatoare = lunile[index_ultim_element_non_nil]
        puts "Ultima lună care nu este nil este: #{luna_corespunzatoare}"
      else
        puts "Nu s-a găsit o valoare non-nil în intervalul specificat."
        luna_corespunzatoare = "nimic"
      end
  
      # Creează o înregistrare în Listacanal2 pentru fiecare email, inclusiv luna corespunzătoare, dacă este disponibilă
      Listacanal3.create!(email: email, platit: luna_corespunzatoare)
  
      emailuri_importate += 1
    end
  
    # Afișează un mesaj cu numărul de emailuri importate
    if emailuri_importate > 0
      flash[:notice] = "#{emailuri_importate} adrese de email au fost importate cu succes în listacanal3."
    else
      flash[:alert] = "Niciun email nou nu a fost adăugat în listacanal3."
    end
  
    # Redirecționează la o pagină după finalizarea importului, de exemplu înapoi la index
    redirect_to panouadmin_path
  end

  def index
    unless current_user&.role == 1
      redirect_to root_path, alert: "Acces restricționat!" and return
    end
    @tvs = Tv.order(created_at: :desc)
  end

  # GET /tvs/1 or /tvs/1.json
  def show
    unless current_user.role == 1
      redirect_to root_path, alert: "Accesul restricționat!" and return
    end
  end

  # GET /tvs/new
  def new
    unless current_user&.role == 1
      redirect_to root_path, alert: "Acces restricționat!" and return
    end
    @tv = Tv.new
  end

  # GET /tvs/1/edit
  def edit
    unless current_user&.role == 1
      redirect_to root_path, alert: "Acces restricționat!" and return
    end
  end

  # POST /tvs or /tvs.json
  def create
    unless current_user&.role == 1
      redirect_to root_path, alert: "Acces restricționat!" and return
    end
    @tv = Tv.new(tv_params)

    respond_to do |format|
      if @tv.save
        format.html { redirect_to tv_url(@tv), notice: "Tv was successfully created." }
        format.json { render :show, status: :created, location: @tv }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tv.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tvs/1 or /tvs/1.json
  def update
    respond_to do |format|
      if @tv.update(tv_params)
        format.html { redirect_to tv_url(@tv), notice: "Tv was successfully updated." }
        format.json { render :show, status: :ok, location: @tv }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tv.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tvs/1 or /tvs/1.json
  def destroy
    @tv.destroy

    respond_to do |format|
      format.html { redirect_to tvs_url, notice: "Tv was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tv
      @tv = Tv.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tv_params
      params.require(:tv).permit(:denumire, :link, :cine, :canal, :datainceput, :orainceput, :mininceput, :datasfarsit, :orasfarsit, :minsfarsit, :user_id, :referinta)
    end
end
