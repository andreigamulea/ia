class RasayanaController < ApplicationController
  def modul1
    data_prag = Date.new(2024, 2, 25)
  
    if current_user
      puts("User logat: #{current_user.id}")
  
      if current_user.role == 1
        # Utilizator cu role 1 are acces direct la video-uri
        @has_access = true
        valid_prods = ['cod110']
        expired_prods = []
        all_purchased = ['cod110']
        @a_cumparat_macar_un_cod = true
        @prods = Prod.none
        @prods_cumparate = Prod.where(cod: all_purchased)
      else
        # Obține codurile produselor cumpărate și datele de început și sfârșit
        purchased_prods = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
                                     .joins(:prod)
                                     .where(prods: { curslegatura: 'vajikarana1', status: 'activ' })
                                     .pluck('prods.cod', 'datainceput', 'datasfarsit')
  
        purchased_prods ||= []
  
        puts("Produse cumpărate cu date: #{purchased_prods}")
  
        valid_prods = purchased_prods.select { |_, datainceput, _| datainceput && datainceput + 90.days >= Date.today }.map(&:first)
        expired_prods = purchased_prods.select { |_, datainceput, _| datainceput && datainceput + 90.days < Date.today }.map(&:first)
  
        puts("Produse valabile: #{valid_prods}")
        puts("Produse expirate: #{expired_prods}")
  
        all_purchased = purchased_prods.map(&:first).uniq
        @a_cumparat_macar_un_cod = all_purchased.any?
  
        # Determină produsele de afișat în funcție de condiții
        if @a_cumparat_macar_un_cod
          if all_purchased.include?('cod108') && all_purchased.include?('cod109')
            @prods = expired_prods.include?('cod109') ? Prod.where(cod: 'cod109') : Prod.none
          elsif all_purchased.include?('cod110')
            @prods = expired_prods.include?('cod110') ? Prod.where(cod: 'cod109') : Prod.none
          elsif all_purchased.include?('cod108')
            @prods = Prod.where(cod: 'cod109')
          else
            @prods = Prod.where(cod: 'cod110')
          end
        else
          @prods = Prod.where(cod: 'cod110')
        end
  
        # Determină accesul
        @has_access = valid_prods.include?('cod110') || valid_prods.include?('cod109')
        @prods_cumparate = Prod.where(cod: all_purchased)
      end
  
      puts("Produse afișate: #{@prods.pluck(:cod) if @prods}")
      puts("Are acces? : #{@has_access}")
      puts("Produse cumpărate: #{@prods_cumparate.pluck(:cod) if @prods_cumparate}")
  
      # Determină video-urile corespunzătoare
      @myvideo13 = if @a_cumparat_macar_un_cod
                     if current_user.limba == 'EN'
                       Video.where(tip: 'vajikarana1').where('ordine > ? AND ordine < ?', 4000, 5000).order(ordine: :asc)
                     else
                       Video.where(tip: 'vajikarana1').where('ordine <= ?', 1000).order(ordine: :asc)
                     end
                   else
                     Video.none
                   end
  
      puts("Video-uri afișate: #{@myvideo13.pluck(:id) if @myvideo13}")
  
    else
      # Utilizator neautentificat
      puts("User nelogat")
      @prods = Prod.where(curslegatura: 'vajikarana1', status: 'activ').where(cod: 'cod110')
      @has_access = false
      @prods_cumparate = Prod.none
      @videos_correspondente = Video.none
      @myvideo13 = Video.none
      @a_cumparat_macar_un_cod = false
  
      puts("Produse afișate pentru user nelogat: #{@prods.pluck(:cod) if @prods}")
    end
  
    puts("Data prag + 90 zile= : #{data_prag + 90.days}")
  end
end
