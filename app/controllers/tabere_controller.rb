class TabereController < ApplicationController
  def tayv24
    data_prag = Date.new(2024, 5, 19)
  
    if current_user
      puts("User logat: #{current_user.id}")
  
      if current_user.role == 1
        # Utilizator cu role 1 are acces direct la video-uri
        @has_access = true
        valid_prods = ['cod86']
        expired_prods = []
        all_purchased = ['cod86']
        @a_cumparat_macar_un_cod = true
        @prods = Prod.none
        @prods_cumparate = Prod.where(cod: all_purchased)
      else
        # Obține codurile produselor cumpărate și datele de început și sfârșit
        purchased_prods = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
                                     .joins(:prod)
                                     .where(prods: { curslegatura: 'nutritie4', status: 'activ' })
                                     .pluck('prods.cod', 'datainceput', 'datasfarsit')
  
        purchased_prods1 = ComenziProd1.where(user_id: current_user.id, validat: 'Finalizata')
                                       .joins(:prod)
                                       .where(prods: { curslegatura: 'nutritie4', status: 'activ' })
                                       .pluck('prods.cod', 'datainceput', 'datasfarsit')
  
        purchased_prods ||= []
        purchased_prods1 ||= []
  
        all_purchased_prods = purchased_prods + purchased_prods1
  
        puts("Produse cumpărate cu date: #{all_purchased_prods}")
  
        valid_prods = all_purchased_prods.select { |_, datainceput, _| datainceput && datainceput + 90.days >= Date.today }.map(&:first)
        expired_prods = all_purchased_prods.select { |_, datainceput, _| datainceput && datainceput + 90.days < Date.today }.map(&:first)
  
        puts("Produse valabile: #{valid_prods}")
  
        all_purchased = all_purchased_prods.map(&:first).uniq
        @a_cumparat_macar_un_cod = all_purchased.any?
  
        if @a_cumparat_macar_un_cod
          if all_purchased.include?('cod85') && all_purchased.include?('cod88')
            @prods = Prod.none
            @has_access = true
          elsif all_purchased.include?('cod86')
            @has_access = true
            @prods = Prod.none
          elsif all_purchased.include?('cod85')
            @prods = Prod.where(cod: 'cod88')
            puts("are doar cod85 platit")
          else
            @prods = Prod.where(cod: ['cod85', 'cod86']).order(:id)
          end
        else
          @prods = Prod.where(cod: ['cod85', 'cod86']).order(:id)
        end
  
        @has_access ||= valid_prods.include?('cod86') || valid_prods.include?('cod88')
        @prods_cumparate = Prod.where(cod: all_purchased)
      end
  
      puts("Produse afișate: #{@prods.pluck(:cod) if @prods}")
      puts("Are acces? : #{@has_access}")
      puts("Produse cumpărate: #{@prods_cumparate.pluck(:cod) if @prods_cumparate}")
  
      @myvideo13 = if @a_cumparat_macar_un_cod
                     if current_user.limba == 'EN'
                       Video.where(tip: 'nutritie4').where('ordine > ? AND ordine < ?', 2000, 3000).order(ordine: :asc)
                     else
                       Video.none
                     end
                   else
                     Video.none
                   end
  
      if @has_access
        @platit = true
        puts("sunt in has acces")
        if current_user.limba == 'EN'
          puts("sunt in limba en")
          @myvideo = Video.where(tip: 'nutritie4').where('(ordine >= ? AND ordine <= ?) OR (ordine > ? AND ordine < ?)', 1, 1000, 4000, 5000).order(ordine: :asc)
        else
          puts("NU sunt in limba en")
          @myvideo = Video.where(tip: 'nutritie4').where('ordine <= ?', 1000).order(ordine: :asc)
        end
        puts("Numarul: #{@myvideo.count}")
        
      else
        puts("sunt in has acces NU")
        @myvideo13 = Video.none
      end
    else
      ## Utilizator neautentificat
      puts("User nelogat")
      @prods = Prod.where(curslegatura: 'nutritie4', status: 'activ').where(cod: ['cod85', 'cod86']).order(:id)
      @has_access = false
      @prods_cumparate = Prod.none
      @videos_correspondente = Video.none
      @myvideo13 = Video.none
      @a_cumparat_macar_un_cod = false
    end
  
    if data_prag
      puts("Data prag + 90 zile= : #{data_prag + 90.days}")
    end
end
end
