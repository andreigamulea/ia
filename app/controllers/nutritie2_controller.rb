class Nutritie2Controller < ApplicationController
  def index
    #functioneaza f bine. este luata in considerare si datasfarsit pana cand a platit sa aiba acces
    # dupa cele 60 zile acces ii apare sa plateasca din nou 200 lei pt acces - si daca plateste va avea din nou acces
    # cine plateste 780 lei pe langa comanda finalizata ce apare in ComenziProd; apare o inregistrare noua
    #    in UserModulecursuri: modulecursuri_id  3 finalizata 
    #daca este in UserModulecursuri cu modulecursuri_id 3 finalizata atunci poate plati 200 pt acces digital
    @has_access = current_user&.role == 1
  
    # Verifică dacă userul curent există în UserModulecursuri cu condițiile specificate
    if current_user
      @has_access ||= UserModulecursuri.exists?(user_id: current_user.id, 
                                                modulecursuri_id: 3, 
                                                validat: "Finalizata")
    end
    @condition1 = if current_user
      if current_user.role == 1
        true
      else
        comanda = ComenziProd.where(user_id: current_user.id, validat: "Finalizata")
                            .where(prod_id: Prod.where(cod: ['cod72', 'cod74']).select(:id))
                            .order(datasfarsit: :desc)
                            .first
    
        if comanda && comanda.datasfarsit
          comanda.datasfarsit >= Date.today
        else
          false
        end
      end
    end
    
    ########################
    if current_user
      
      @condition2 = false
      special_emails = ['cristina.nedescu@gmail.com']

      # Verificare dacă utilizatorul curent are un email special
      if special_emails.include?(current_user.email)
        @condition2 = true
        @has_access = true
      end

      # Logica pentru produsele achiziționate
      purchased_prods = ComenziProd.where(user_id: current_user.id, validat: 'Finalizata')
        .joins(:prod)
        .where(prods: { curslegatura: 'nutritie', status: 'activ' })
        .pluck('prods.cod', 'datainceput', 'datasfarsit')

      purchased_prods1 = ComenziProd1.where(user_id: current_user.id, validat: 'Finalizata')
        .joins(:prod)
        .where(prods: { curslegatura: 'nutritie', status: 'activ' })
        .pluck('prods.cod', 'datainceput', 'datasfarsit')

      valid_prods = (purchased_prods + purchased_prods1).select do |prod|
        prod_end_date = prod[2] # presupunem că 'datasfarsit' este al treilea element din array
        puts("prod_end_date=#{prod_end_date}") # Mutat în interiorul blocului
        prod_end_date && prod_end_date >= Date.today
      end.map(&:first) # preluăm doar codurile produselor valide

      # Setare @has_access și @condition2 în funcție de produsele valide
      unless valid_prods.empty?
        @has_access = true
        @condition2 = true
      end
       
  end
  puts("condition2=#{@condition2}")
    #################################
    
    if @has_access
      @myvideo4 = Video.where(tip: 'nutritie2').where('ordine > ? AND ordine < ?', 3000, 4000).order(ordine: :asc)
  
    end  
    if !current_user      
      @prods = Prod.where(curslegatura: 'nutritie2', status: 'activ', cod: 'cod72')
    elsif current_user && @has_access && (@condition1 || @condition2)
      @prods = Prod.none
      @platit=true # variabila care permite accesul la video
      @myvideo = Video.where(tip: 'nutritie2').where('ordine > ? AND ordine < ?', 0, 1000).order(ordine: :asc)  
    elsif @has_access
      
      @prods = Prod.where(curslegatura: 'nutritie2', status: 'activ', cod: 'cod74')
    else
      @prods = Prod.where(curslegatura: 'nutritie2', status: 'activ', cod: 'cod72')
    end
  end
end
