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
  end
  
  

  
  
end
