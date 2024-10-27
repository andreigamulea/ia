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
    unless user_signed_in?
      puts("autentificareee")
      flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
      redirect_to new_user_session_path
      return false
    end
    lunile = ["septembrie", "octombrie", "noiembrie", "decembrie", "ianuarie", "februarie", "martie", "aprilie", "mai", "iunie", "iulie", "august"]
  
    # Utilizatorii cu role == 1 au acces automat
    unless current_user.role == 1
      inregistrare_user = Listacanal2.find_by(email: current_user.email)
  
      if inregistrare_user.nil?
        redirect_to root_path and return
      end
  
      if inregistrare_user.platit == "nimic"
        redirect_to root_path and return
      end
  
      luna_curenta_romana = luna_in_romana(Time.current.in_time_zone('Europe/Bucharest').strftime("%B"))
      index_luna_curenta = lunile.index(luna_curenta_romana)
      index_luna_platit = lunile.index(inregistrare_user.platit)
      index_luna_anterioara = (index_luna_curenta - 1) % lunile.length
  
      if index_luna_platit.nil? || index_luna_curenta.nil? || (index_luna_platit < index_luna_curenta && index_luna_platit < index_luna_anterioara)
        redirect_to root_path and return
      end
    end
  
    now_bucharest = Time.current.in_time_zone('Europe/Bucharest')
    @now_bucharest = now_bucharest
    data_curenta = @now_bucharest.to_date
    @orare_inceput_sfarsit_azi = Tv.where(datainceput: data_curenta, canal: 2).pluck(:orainceput, :orasfarsit).flat_map { |orainceput, orasfarsit| [orainceput, orasfarsit] }.uniq
  
    @orare_inceput_sfarsit_azi = @orare_inceput_sfarsit_azi.map { |ora| ora.strftime('%H:%M') }
  
    @myvideo1 = Tv.where(canal: 2)
                  .where("datainceput <= ? AND datasfarsit >= ?", now_bucharest.to_date, now_bucharest.to_date)
                  .to_a
                  .detect do |tv|
                    ora_inceput_ajustata = tv.orainceput.change(year: now_bucharest.year, month: now_bucharest.month, day: now_bucharest.day, zone: 'Europe/Bucharest')
                    
                    if tv.datasfarsit == tv.datainceput
                      ora_sfarsit_ajustata = tv.orasfarsit.change(year: now_bucharest.year, month: now_bucharest.month, day: now_bucharest.day, zone: 'Europe/Bucharest')
                    else
                      ora_sfarsit_ajustata = tv.orasfarsit.change(year: tv.datasfarsit.year, month: tv.datasfarsit.month, day: tv.datasfarsit.day, zone: 'Europe/Bucharest')
                    end
  
                    now_bucharest >= ora_inceput_ajustata && now_bucharest <= ora_sfarsit_ajustata
                  end
  
    puts "Video selectat: #{@myvideo1 ? @myvideo1.id : 'Niciunul'}"
  
    # Dacă @myvideo1 există, căutăm videouri cu același cod în tabela Video
    if @myvideo1
      # Găsim videoclipul în tabela Video care are același link ca @myvideo1
      video_gasit = Video.find_by(link: @myvideo1.link)
  
      if video_gasit
        # Căutăm toate videourile cu același cod
        @myvideos = Video.where(cod: video_gasit.cod)
        @nr_video_gasite = @myvideos.count
        puts("Numarul de videouri gasite cu acelasi cod este de : #{@nr_video_gasite}")
      else
        @nr_video_gasite = 0
        puts("Nu a fost găsit niciun video cu același link în tabela Video.")
      end
    else
      @nr_video_gasite = 0
      puts("Nu a fost selectat niciun video pentru verificarea codului.")
    end
  
    # Restul codului
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
    unless user_signed_in?
      puts("autentificareee")
      flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
      redirect_to new_user_session_path
      return false
    end
    lunile = ["septembrie", "octombrie", "noiembrie", "decembrie", "ianuarie", "februarie", "martie", "aprilie", "mai", "iunie", "iulie", "august"]
  
    # Utilizatorii cu role == 1 au acces automat
    unless current_user.role == 1
      inregistrare_user = Listacanal3.find_by(email: current_user.email)
  
      if inregistrare_user.nil?
        redirect_to root_path and return
      end
  
      if inregistrare_user.platit == "nimic"
        redirect_to root_path and return
      end
  
      luna_curenta_romana = luna_in_romana(Time.current.in_time_zone('Europe/Bucharest').strftime("%B"))
      index_luna_curenta = lunile.index(luna_curenta_romana)
      index_luna_platit = lunile.index(inregistrare_user.platit)
      index_luna_anterioara = (index_luna_curenta - 1) % lunile.length
  
      if index_luna_platit.nil? || index_luna_curenta.nil? || (index_luna_platit < index_luna_curenta && index_luna_platit < index_luna_anterioara)
        redirect_to root_path and return
      end
    end
  
    now_bucharest = Time.current.in_time_zone('Europe/Bucharest')
    @now_bucharest = now_bucharest
    data_curenta = @now_bucharest.to_date
    @orare_inceput_sfarsit_azi = Tv.where(datainceput: data_curenta, canal: 3).pluck(:orainceput, :orasfarsit).flat_map { |orainceput, orasfarsit| [orainceput, orasfarsit] }.uniq
  
    @orare_inceput_sfarsit_azi = @orare_inceput_sfarsit_azi.map { |ora| ora.strftime('%H:%M') }
  
    @myvideo1 = Tv.where(canal: 3)
                  .where("datainceput <= ? AND datasfarsit >= ?", now_bucharest.to_date, now_bucharest.to_date)
                  .to_a
                  .detect do |tv|
                    ora_inceput_ajustata = tv.orainceput.change(year: now_bucharest.year, month: now_bucharest.month, day: now_bucharest.day, zone: 'Europe/Bucharest')
                    
                    if tv.datasfarsit == tv.datainceput
                      ora_sfarsit_ajustata = tv.orasfarsit.change(year: now_bucharest.year, month: now_bucharest.month, day: now_bucharest.day, zone: 'Europe/Bucharest')
                    else
                      ora_sfarsit_ajustata = tv.orasfarsit.change(year: tv.datasfarsit.year, month: tv.datasfarsit.month, day: tv.datasfarsit.day, zone: 'Europe/Bucharest')
                    end
  
                    now_bucharest >= ora_inceput_ajustata && now_bucharest <= ora_sfarsit_ajustata
                  end
  
    puts "Video selectat: #{@myvideo1 ? @myvideo1.id : 'Niciunul'}"
  
    # Dacă @myvideo1 există, căutăm videouri cu același cod în tabela Video
    if @myvideo1
      # Găsim videoclipul în tabela Video care are același link ca @myvideo1
      video_gasit = Video.find_by(link: @myvideo1.link)
  
      if video_gasit
        # Căutăm toate videourile cu același cod
        @myvideos = Video.where(cod: video_gasit.cod)
        @nr_video_gasite = @myvideos.count
        puts("Numarul de videouri gasite cu acelasi cod este de : #{@nr_video_gasite}")
      else
        @nr_video_gasite = 0
        puts("Nu a fost găsit niciun video cu același link în tabela Video.")
      end
    else
      @nr_video_gasite = 0
      puts("Nu a fost selectat niciun video pentru verificarea codului.")
    end
  
    # Restul codului
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
  
require 'net/ssh'
require 'net/sftp'
def rasayana1
  unless user_signed_in?
    flash[:alert] = "Trebuie să vă autentificați pentru a accesa acest curs."
    redirect_to new_user_session_path
    return false
  end
  # Select the 5 products based on curslegatura and cod fields
  products = Prod.where(curslegatura: 'rasayana1', cod: ['cod234', 'cod235', 'cod236', 'cod237', 'cod238','cod243'])
    
  # User not logged in case
  if current_user.nil?
    # Display only the first and last products (p1 and p5)
    @prods = products.where(cod: ['cod234', 'cod238'])
    @nr_luni_achitate = 0 # No purchases, no months paid
  else
    # User is logged in, check purchases in ComenziProd
    purchased_prods = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
                                 .joins(:prod)
                                 .where(prods: { curslegatura: 'rasayana1', status: 'activ' })
                                 .pluck('prods.cod')

    # Determine which products to show based on what has been purchased
    if purchased_prods.include?('cod238') # p5
      @prods = [] # None if p5 is purchased
      @nr_luni_achitate = 4
    elsif purchased_prods.include?('cod234') && purchased_prods.include?('cod235') && purchased_prods.include?('cod236') && purchased_prods.include?('cod237')
      @prods = [] # None if all p1, p2, p3, p4 are purchased
      @nr_luni_achitate = 4
    elsif purchased_prods.include?('cod234') && purchased_prods.include?('cod235') && purchased_prods.include?('cod236')
      @prods = products.where(cod: 'cod237') # p4 only
      @nr_luni_achitate = 3
    elsif purchased_prods.include?('cod234') && purchased_prods.include?('cod235')
      @prods = products.where(cod: 'cod236') # p3 only
      @nr_luni_achitate = 2
    elsif purchased_prods.include?('cod234')
      @prods = products.where(cod: 'cod235') # p2 only
      @nr_luni_achitate = 1
    elsif purchased_prods.include?('cod243')
      @prods = products.where(cod: 'cod243') # p2 only
      @nr_luni_achitate = 4
    else
      # If no purchases from the 5 products, show p1 and p5
      @prods = products.where(cod: ['cod234', 'cod238'])
      @nr_luni_achitate = 0
    end
  end
  ###############################
  if @nr_luni_achitate <= 0 && current_user.role != 1
    flash[:alert] = "Verificati va rugam platile facute!"
    redirect_to new_user_session_path
    return false
  end
  
  
  ###############################

  now_bucharest = Time.current.in_time_zone('Europe/Bucharest')
  @now_bucharest = now_bucharest
  data_curenta = @now_bucharest.to_date
  # Colectează toate 'orainceput' pentru înregistrările din data curentă
  #@orare_inceput_azi = Tv.where(datainceput: data_curenta).pluck(:orainceput, :orasfarsit)
  @orare_inceput_sfarsit_azi = Tv.where(datainceput: data_curenta, canal: 101).pluck(:orainceput, :orasfarsit).flat_map { |orainceput, orasfarsit| [orainceput, orasfarsit] }.uniq

 
  # Convertim fiecare ora de inceput in format HH:MM pentru a facilita comparatia in JavaScript
  @orare_inceput_sfarsit_azi = @orare_inceput_sfarsit_azi.map { |ora| ora.strftime('%H:%M') }
  

  @myvideo1 = Tv.where(canal: 101)
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
      
      @myvideo_debian = Video.find_by(link: @myvideo)
      if @myvideo_debian.link_debian!=nil
        ## Detalii conexiune SSH
          ssh_host = 'ayush.go.ro'
          ssh_port = 22
          username = 'ayushayush'
          password = 'bhairava'
          ## #EXT-X-KEY:METHOD=AES-128,URI="https://ayushcell.ro/get_priority_flag",IV=0x0123456789abcdef0123456789abcdef
          #@video_url_m3u8 = 'https://ayush.go.ro/ormus_output.m3u8'  #mnt/AyushCell/ormus...
          #@video_url_m3u8 = 'https://ayush.go.ro/Cursuri/Rasayana/Modul 1/M01C04/output.m3u8'  #mnt/AyushCell/ormus...
          @video_url_m3u8 =  @myvideo_debian.link_debian
          
      end  


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
