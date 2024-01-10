class Nutritie2Controller < ApplicationController
  def index
    #functioneaza f bine. este luata in considerare si datasfarsit pana cand a platit sa aiba acces
    # dupa cele 60 zile acces ii apare sa plateasca din nou 200 lei pt acces - si daca plateste va avea din nou acces
    @has_access = current_user&.role == 1
  
    # Verifică dacă userul curent există în UserModulecursuri cu condițiile specificate
    if current_user
      @has_access ||= UserModulecursuri.exists?(user_id: current_user.id, 
                                                modulecursuri_id: 3, 
                                                validat: "Finalizata")
    end
    @condition1 = if current_user
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
    
    
    if @has_access
      @myvideo4 = Video.where(tip: 'nutritie2').where('ordine > ? AND ordine < ?', 3000, 4000).order(ordine: :asc)
  
    end  
    if !current_user      
      @prods = Prod.where(curslegatura: 'nutritie2', status: 'activ', cod: 'cod72')
    elsif current_user && @has_access && @condition1
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
