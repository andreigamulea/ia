class Nutritie1Controller < ApplicationController
  def index
    #functioneaza f bine. este luata in considerare si datasfarsit pana cand a platit sa aiba acces
    # dupa cele 60 zile acces ii apare sa plateasca din nou 200 lei pt acces - si daca plateste va avea din nou acces
    # cine plateste 780 lei pe langa comanda finalizata ce apare in ComenziProd apar 2 inregistrari noi
    #    in UserModulecursuri: modulecursuri_id  1 si 2 finalizate iar daca plateste completarea de 300 lei apare
    #    si in UserModulecursuri: modulecursuri_id  2 finalizata
    #daca este in UserModulecursuri cu modulecursuri_id  1 si 2 finalizate atunci poate plati 200 pt acces digital

    @has_access = current_user&.role == 1

  # Verifică dacă userul curent există în UserModulecursuri cu condițiile specificate
  if current_user
    @has_access ||= UserModulecursuri.where(user_id: current_user.id, validat: "Finalizata")
                                      .where(modulecursuri_id: [1, 2])
                                      .group(:user_id)
                                      .having('COUNT(DISTINCT modulecursuri_id) = 2')
                                      .exists?
  end

  @has_access1 = if current_user
    has_access_module_1 = UserModulecursuri.exists?(user_id: current_user.id, 
                                                    modulecursuri_id: 1, 
                                                    validat: "Finalizata")
  
    has_access_module_2 = UserModulecursuri.exists?(user_id: current_user.id, 
                                                    modulecursuri_id: 2, 
                                                    validat: "Finalizata")
  
    has_access_module_1 && !has_access_module_2
  end
  
 
  

  @condition1 = if current_user
    if current_user.role == 1
      true
    else
      comanda = ComenziProd.where(user_id: current_user.id, validat: "Finalizata")
                          .where(prod_id: Prod.where(cod: ['cod73', 'cod75']).select(:id))
                          .order(datasfarsit: :desc)
                          .first
  
      if comanda && comanda.datasfarsit
        comanda.datasfarsit >= Date.today
      else
        false
      end
    end
  end
  
  

  

  if @has_access #@myvideo4  este pentru cei care au platit tot nutritie1 p1+p2 - vor avea acces pana la curs 8b
    #voi nota videourile 5,6,7,8 de la 2001 in sus
    @myvideo4 = Video.where(tip: 'nutritie1').where('ordine > ? AND ordine < ?', 1000, 3000).order(ordine: :asc)  
  end  
  if @has_access1  #@myvideo3  este pentru cei care au platit doar nutritie1 p1 - vor avea acces pana la curs 4b
    @myvideo3 = Video.where(tip: 'nutritie1').where('ordine > ? AND ordine < ?', 1000, 2000).order(ordine: :asc)  
  end  
  if !current_user   
    puts("da0")   
    @prods = Prod.where(curslegatura: 'nutritie1', status: 'activ', cod: 'cod73')
  elsif current_user && @has_access && @condition1
    @prods = Prod.none
    @platit=true # variabila care permite accesul la video
    @myvideo = Video.where(tip: 'nutritie1').where('ordine > ? AND ordine < ?', 0, 1000).order(ordine: :asc)
  elsif current_user && @has_access1
    puts("da1")
    @condition = if current_user
      comanda = ComenziProd.where(user_id: current_user.id, validat: "Finalizata")
                          .where(prod_id: Prod.find_by(cod: 'cod76')&.id)
                          .order(datasfarsit: :desc)
                          .first
    
      if comanda && comanda.datasfarsit
        comanda.datasfarsit >= Date.today
      else
        false
      end
    end
    
    


        if @condition
          puts("da2")
          @prods = Prod.where(curslegatura: 'nutritie1', status: 'activ', cod: 'cod75')
        else
          puts("da3")
          @prods = Prod.where(curslegatura: 'nutritie1', status: 'activ', cod: 'cod76')  
          
        end  
  elsif current_user && @has_access
    @prods = Prod.where(curslegatura: 'nutritie1', status: 'activ', cod: 'cod75')
    puts("da a platit dar apare")
  else
    puts("da4")
    @prods = Prod.where(curslegatura: 'nutritie1', status: 'activ', cod: 'cod73')
  end 
end
end

