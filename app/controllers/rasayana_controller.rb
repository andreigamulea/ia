class RasayanaController < ApplicationController
  def modul1
    @nr_luni_achitate = 0 # Valoare implicită
    @has_acces_video = 0 # Implicit, fără acces video
    data_prag = Date.new(2025, 4, 30)
    current_date = Date.today
  
    # Selectăm cele 7 produse pe baza campurilor curslegatura și cod
    products = Prod.where(curslegatura: 'rasayana1', cod: ['cod234', 'cod235', 'cod236', 'cod237', 'cod238', 'cod242', 'cod243'])
  
    # Cazul în care utilizatorul nu este logat
    if current_user.nil?
      # Afișăm produsele cod234, cod238 și cod243
      @prods = products.where(cod: ['cod234', 'cod238', 'cod243'])
    else
      # Utilizatorul este logat, verificăm achizițiile în ComenziProd
      purchased_prods = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
                                   .joins(:prod)
                                   .where(prods: { curslegatura: 'rasayana1', status: 'activ' })
                                   .pluck('prods.cod')
  
      # Verificăm dacă a fost cumpărat cod243 (valoare directă pentru @nr_luni_achitate și @has_acces_video)
      if purchased_prods.include?('cod243')
        @nr_luni_achitate = 4
        @has_acces_video = 4
        @prods = [] # Nu afișăm alte produse dacă cod243 este cumpărat
      elsif purchased_prods.include?('cod238')
        # Cod238 este cumpărat, echivalent cu achiziția celor 4 luni
        @nr_luni_achitate = 4
        @has_acces_video = 0 # Fără acces video deoarece cod242 nu este cumpărat
        @prods = products.where(cod: 'cod242') # Afișăm doar cod242 pentru acces video
      else
        # Verificăm pentru codurile 234, 235, 236, 237
        @nr_luni_achitate = purchased_prods.count { |cod| ['cod234', 'cod235', 'cod236', 'cod237'].include?(cod) }
  
        # Dacă a fost cumpărat doar cod234, afișăm și cod235 și cod242 (pentru acces video)
        if @nr_luni_achitate == 1
          @prods = products.where(cod: ['cod235', 'cod242'])
        elsif @nr_luni_achitate == 2
          @prods = products.where(cod: ['cod236', 'cod242'])
        elsif @nr_luni_achitate == 3
          @prods = products.where(cod: ['cod237', 'cod242'])
        elsif @nr_luni_achitate == 4
          @prods = [] # Toate produsele au fost cumpărate
        else
          @prods = products.where(cod: ['cod234', 'cod238', 'cod243']) # Dacă nu au fost cumpărate produse, afișăm 234, 238 și 243
        end
      end
  
      # Verificăm dacă a fost cumpărat cod242
      if purchased_prods.include?('cod242')
        # Setăm @has_acces_video în funcție de numărul de luni achitate
        @has_acces_video = @nr_luni_achitate
  
        # După ce cod242 este cumpărat, nu mai afișăm cod242
        @prods = @prods.where.not(cod: 'cod242') if @prods.present?
      end
    end
  end
  
  
  

end
