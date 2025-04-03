class RasayanaController < ApplicationController
  def modul1  # #ATENTIE nu e facaut pana cand au acces!!! s-a incheiat la 31 Ianuarie si o sa pun pana la datasfarsit
    @myvideo1 = Video.find_by(link: 'suMeHXOiYtk') #prezentare rasayana
    @myvideo = @myvideo1.link if @myvideo1

    @nr_luni_achitate = 0 # Valoare implicită
    @has_acces_video = 0 # Implicit, fără acces video
    data_prag = Date.new(2025, 4, 30)
    current_date = Date.today

    # Inițializare variabile pentru a preveni erorile
    @myvideo_rasayana_m1 = []
    @myvideo_rasayana_m1_seminarii = []

    # Verificăm dacă utilizatorul are rolul 1 pentru acces complet
    if current_user&.role == 1
      @myvideo_rasayana_m1 = Video.where(tip: 'rasayana1')
                                  .where('ordine >= ? AND ordine <= ?', 0, 1000)
                                  .order(ordine: :asc).to_a
      @myvideo_rasayana_m1_seminarii = Video.where(tip: 'rasayana1')
                                            .where('ordine > ? AND ordine < ?', 1000, 2000)
                                            .order(ordine: :asc).to_a
      @prods = [] # Nu afișăm alte produse
      @has_acces_video = 4
      @nr_luni_achitate = 4
    else
      products = Prod.where(curslegatura: 'rasayana1', cod: ['cod234', 'cod235', 'cod236', 'cod237', 'cod238', 'cod242', 'cod243', 'cod241'])
  
      if current_user.nil?
        @prods = products.where(cod: ['cod234', 'cod238', 'cod243'])
      else
        purchased_prods = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
                                     .joins(:prod)
                                     .where(prods: { curslegatura: 'rasayana1', status: 'activ' })
                                     .pluck('prods.cod')
  
        if purchased_prods.include?('cod243')
          @nr_luni_achitate = 4
          @has_acces_video = 4
          @prods = []
          @myvideo_rasayana_m1 = Video.where(tip: 'rasayana1')
                                      .where('ordine >= ? AND ordine <= ?', 0, 1000)
                                      .order(ordine: :asc).to_a
          @myvideo_rasayana_m1_seminarii = Video.where(tip: 'rasayana1')
                                                .where('ordine > ? AND ordine < ?', 1000, 2000)
                                                .order(ordine: :asc).to_a
        elsif purchased_prods.include?('cod238')
          puts("sunt aici1")
          @nr_luni_achitate = 4
          @has_acces_video = 4
          @prods = Prod.where(curslegatura: 'rasayana1', cod: ['cod242'])
                    @myvideo_rasayana_m1 = Video.where(tip: 'rasayana1')
                                      .where('ordine >= ? AND ordine <= ?', 0, 1000)
                                      .order(ordine: :asc).to_a
          @myvideo_rasayana_m1_seminarii = Video.where(tip: 'rasayana1')
                                                .where('ordine > ? AND ordine < ?', 1000, 2000)
                                                .order(ordine: :asc).to_a
        else
          
          @nr_luni_achitate = purchased_prods.count { |cod| ['cod234', 'cod235', 'cod236', 'cod237'].include?(cod) }
          if @nr_luni_achitate == 1
            @prods = products.where(cod: ['cod235', 'cod242'])
          elsif @nr_luni_achitate == 2
            @prods = products.where(cod: ['cod236', 'cod242'])
          elsif @nr_luni_achitate == 3
            @prods = products.where(cod: ['cod237', 'cod242'])
          elsif @nr_luni_achitate == 4
            @prods = products.where(cod: ['cod242'])
          else
            @prods = products.where(cod: ['cod234', 'cod238', 'cod243'])
          end
        end
  
        if purchased_prods.include?('cod242')
          @has_acces_video = @nr_luni_achitate
          @prods = @prods.where.not(cod: 'cod242') if @prods.present?
        end

        # Setare @myvideo_rasayana_m1 și @myvideo_rasayana_m1_seminarii în funcție de codurile achiziționate
        if purchased_prods.include?('cod242') && !purchased_prods.include?('cod238') && !purchased_prods.include?('cod243')
          if purchased_prods.include?('cod234')
            luni_incluse = ['octombrie']
            luni_incluse << 'noiembrie' if purchased_prods.include?('cod235')
            luni_incluse << 'decembrie' if purchased_prods.include?('cod236')
            luni_incluse << 'ianuarie' if purchased_prods.include?('cod237')

            @myvideo_rasayana_m1 = Video.where(tip: 'rasayana1', luna: luni_incluse)
                                        .where('ordine >= ? AND ordine <= ?', 0, 1000)
                                        .order(ordine: :asc).to_a
            @myvideo_rasayana_m1_seminarii = Video.where(tip: 'rasayana1', luna: luni_incluse)
                                                  .where('ordine > ? AND ordine < ?', 1000, 2000)
                                                  .order(ordine: :asc).to_a
          end
        end
      end
    end
    puts("Prods este: #{@prods}")
    puts("@nr_luni_achitate=#{@nr_luni_achitate}")
  end

  def seminarii_rasayana 
    @myvideo = 'qAJafWEieVo'
    if current_user.nil?
      @prods = Prod.where(curslegatura: 'rasayana1-seminarii')
      @valid_prods = []
      @has_access = false
    else
      purchased_prods = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
                                   .joins(:prod)
                                   .where(prods: { curslegatura: 'rasayana1-seminarii', status: 'activ' })
                                   .pluck('prods.cod')
  
      valid_product_codes = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
                                       .where('datasfarsit >= ?', Date.today)
                                       .joins(:prod)
                                       .where(prods: { curslegatura: 'rasayana1-seminarii', status: 'activ' })
                                       .pluck('prods.cod')
  
      @valid_prods = valid_product_codes.any? ? Prod.where(cod: valid_product_codes) : []
      @has_access = @valid_prods.any?  # Dacă există produse valide, @has_access = true
  
      @prods = @has_access ? Prod.none : Prod.where(curslegatura: 'rasayana1-seminarii')
  
      @myvideo_rasayana_m1_seminarii = Video.where(tip: 'rasayana1')
                                            .where('ordine > ? AND ordine < ?', 1000, 2000)
                                            .order(ordine: :asc).to_a
    end

    puts("Produse valide: #{@valid_prods.first}")
    puts("HAS_ACCES: #{@has_access}") 
  end
  
  
  
  def seminarii_rasayana 
    @myvideo = 'qAJafWEieVo'
    if current_user.nil?
      @prods = Prod.where(curslegatura: 'rasayana1-seminarii')
      @valid_prods = []
      @has_access = false
    else
      purchased_prods = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
                                   .joins(:prod)
                                   .where(prods: { curslegatura: 'rasayana1-seminarii', status: 'activ' })
                                   .pluck('prods.cod')
  
      valid_product_codes = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
                                       .where('datasfarsit >= ?', Date.today)
                                       .joins(:prod)
                                       .where(prods: { curslegatura: 'rasayana1-seminarii', status: 'activ' })
                                       .pluck('prods.cod')
  
      @valid_prods = valid_product_codes.any? ? Prod.where(cod: valid_product_codes) : []
      @has_access = @valid_prods.any?  # Dacă există produse valide, @has_access = true
  
      @prods = @has_access ? Prod.none : Prod.where(curslegatura: 'rasayana1-seminarii')
  
      @myvideo_rasayana_m1_seminarii = Video.where(tip: 'rasayana1')
                                            .where('ordine > ? AND ordine < ?', 1000, 2000)
                                            .order(ordine: :asc).to_a
    end

    puts("Produse valide: #{@valid_prods.first}")
    puts("HAS_ACCES: #{@has_access}") 
  end
  
  





  def modul2 #ATENTIE nu e facaut pana cand au acces!!! 4.02.2025
   
    #@myvideo = @myvideo1 if @myvideo1
    @myvideo = 'zAe3zVVT6Cw' 
    # Inițializare variabile pentru a preveni erorile
    @myvideo_rasayana_m2 = []
    @myvideo_rasayana_m2_seminarii = []

    @has_access = current_user&.role == 1
    if current_user  
      # Obține ID-urile produselor cumpărate de current_user, care sunt valide și a căror datasfarsit este azi sau în viitor
      purchased_prod_coduri = ComenziProd.where(user_id: current_user.id, 
                                          validat: 'Finalizata', 
                                          datainceput: Date.new(2025, 1, 7)..)                                           
                                   .joins(:prod)
                                   .where(prods: { curslegatura: 'rasayana2' })
                                   .pluck('prods.cod')

      purchased_prod_coduri1 = ComenziProd1.where(user_id: current_user.id, 
                                   validat: 'Finalizata', 
                                   datainceput: Date.new(2025, 1, 7)..)
                            .joins(:prod)
                            .where(prods: { curslegatura: 'rasayana2' })
                            .pluck('prods.cod')
                            
# Adaugă codurile la array-ul existent și elimină duplicatele
purchased_prod_coduri.concat(purchased_prod_coduri1)
purchased_prod_coduri.concat(purchased_prod_coduri1).uniq!
puts("produsele cumparate sunt: #{purchased_prod_coduri}")
@a_cumparat_macar_un_cod = purchased_prod_coduri.any? || current_user.role == 1


  
      # Logica pentru determinarea produselor de afișat în funcție de ce a cumpărat current_user
      if purchased_prod_coduri.include?('cod368') && purchased_prod_coduri.include?('cod369')
        @prods = Prod.none
        @has_access = true
      elsif purchased_prod_coduri.include?('cod370')
              @has_access = true
              @prods = Prod.none

      elsif purchased_prod_coduri.include?('cod368')
        @prods = Prod.where(cod: 'cod369')
        @has_access = false
      
      else
        # Dacă nu a cumpărat niciunul, afișează produsele cu cod=cod108 și cod=cod110
        @prods = Prod.where(cod: ['cod368', 'cod370'], status: 'activ')
        @has_access = false
      end
  
      @prods_cumparate = Prod.where(cod: purchased_prod_coduri)
             
    else
      # Dacă nu există un current_user, afișează produsele cu cod=cod108 și cod=cod110
      @prods = Prod.where(curslegatura: 'rasayana2', status: 'activ').where(cod: ['cod368', 'cod370']).order(:id)
      @prods_cumparate = Prod.none
      @videos_correspondente = Video.none
    end

     

      if current_user && current_user.role==1
        @has_access = true
      end  
      puts("Are acces? : #{@has_access}")
      if @a_cumparat_macar_un_cod
                    if current_user && current_user.limba=='EN'
                      @myvideo_rasayana_m2 = Video.where(tip: 'rasayana2').where('ordine > ? AND ordine < ?', 1000, 2000).order(ordine: :asc)
                      @myvideo_rasayana_m2_seminarii = Video.none
                    else  
                      @myvideo_rasayana_m2 = Video.where(tip: 'rasayana2').where('ordine <= ?', 1000).order(ordine: :asc)
                      @myvideo_rasayana_m2_seminarii = Video.where(tip: 'rasayana2').where('ordine > ? AND ordine < ?', 2000, 3000).order(ordine: :asc)
                       
                        end  
            else  
                      @myvideo_rasayana_m2 = Video.none
                      @myvideo_rasayana_m2_seminarii = Video.none
            end
            
        end
end
