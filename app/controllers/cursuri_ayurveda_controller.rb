class CursuriAyurvedaController < ApplicationController
    def ayurveda_padartha
      #ATENTIE!!!!!!!  nu este facuta valabilitatea. Trebuie vazut pana cand au valibilitate codurile cumparate
      #dupa ce fac valabilitaea pot sterge acest mesaj
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
        @prods = [] ## Nu afișăm alte produse
        @has_acces_video = 4
        @nr_luni_achitate = 4
      else
        products = Prod.where(curslegatura: 'modul_ayurveda_padartha', cod: ['cod315', 'cod316', 'cod317'])
    
        if current_user.nil?
          @prods = products.where(cod: ['cod315',  'cod317'])
        else
          purchased_prods = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
                                       .joins(:prod)
                                       .where(prods: { curslegatura: 'modul_ayurveda_padartha', status: 'activ' })
                                       .pluck('prods.cod')
    
          if purchased_prods.include?('cod317')
            @a_cumparat_macar_un_cod = true
            @a_cumparat_digital = true
            @prods = []
            @myvideo_ayurveda_padartha = Video.where(tip: 'modul_ayurveda_padartha')
                                        .where('ordine >= ? AND ordine <= ?', 0, 1000)
                                        .order(ordine: :asc).to_a
            @myvideo_ayurveda_padartha_seminarii = Video.where(tip: 'modul_ayurveda_padartha')
                                                  .where('ordine > ? AND ordine < ?', 1000, 2000)
                                                  .order(ordine: :asc).to_a
          elsif purchased_prods.include?('cod316')
            puts("sunt aici1")
            @a_cumparat_macar_un_cod = true
            @a_cumparat_digital = true
            @prods = Prod.none
            @myvideo_ayurveda_padartha = Video.where(tip: 'modul_ayurveda_padartha')
                                        .where('ordine >= ? AND ordine <= ?', 0, 1000)
                                        .order(ordine: :asc).to_a
            @myvideo_ayurveda_padartha_seminarii = Video.where(tip: 'modul_ayurveda_padartha')
                                                  .where('ordine > ? AND ordine < ?', 1000, 2000)
                                                  .order(ordine: :asc).to_a
          elsif purchased_prods.include?('cod315')
            @a_cumparat_macar_un_cod = true
            @a_cumparat_digital = false
            @prods = products.where(cod: ['cod316'])
            @myvideo_ayurveda_padartha = Video.none
            @myvideo_ayurveda_padartha_seminarii = Video.none
          else
            @prods = products.where(cod: ['cod315', 'cod317'])
            @myvideo_ayurveda_padartha = Video.none
            @myvideo_ayurveda_padartha_seminarii = Video.none
            end
          end
    
         
        end
      
      
    end    
    # Definește acțiunile dorite aici
  end
  