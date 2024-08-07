class Nutritie3Controller < ApplicationController
  def index
    @has_access = current_user&.role == 1
  
    # Verifică dacă userul curent există în UserModulecursuri cu condițiile specificate
    if current_user
                  @has_access = if current_user
                    if current_user.role == 1
                      true
                    elsif current_user.role == 0
                      acces_initial = ComenziProd.joins(:prod)
                                                 .where(user_id: current_user.id, 
                                                        prods: { cod: ["cod12"] }, 
                                                        validat: "Finalizata")
                                                 .where("to_char(datainceput, 'YYYY') = ?", "2023")
                                                 .exists? ||
                                       (ComenziProd.joins(:prod)
                                                   .where(user_id: current_user.id, 
                                                          prods: { cod: ["cod11"] }, 
                                                          validat: "Finalizata")
                                                   .where("to_char(datainceput, 'YYYY') = ?", "2023")
                                                   .exists? &&
                                        ComenziProd.joins(:prod)
                                                   .where(user_id: current_user.id, 
                                                          prods: { cod: ["cod38"] }, 
                                                          validat: "Finalizata")
                                                   .where("to_char(datainceput, 'YYYY') = ?", "2023")
                                                   .exists?) ||
                                       (ComenziProd.joins(:prod)
                                                   .where(user_id: current_user.id, 
                                                          prods: { cod: ["cod13"] }, 
                                                          validat: "Finalizata")
                                                   .where("to_char(datainceput, 'YYYY') = ?", "2023")
                                                   .exists? &&
                                        ComenziProd.joins(:prod)
                                                   .where(user_id: current_user.id, 
                                                          prods: { cod: ["cod39"] }, 
                                                          validat: "Finalizata")
                                                   .where("to_char(datainceput, 'YYYY') = ?", "2023")
                                                   .exists?)
                    


                      if acces_initial && Date.today <= Date.new(2024, 1, 31)
                        true
                      else
                        comanda_recenta = ComenziProd.where(user_id: current_user.id, validat: "Finalizata")
                                                    .where("datainceput > ?", Date.new(2024, 1, 1))
                                                    .where(prod_id: Prod.where(cod: ["cod12", "cod38"]).select(:id))
                                                    .order(datainceput: :desc)
                                                    .first

                        if comanda_recenta
                          data_expirare = comanda_recenta.datainceput + comanda_recenta.prod.valabilitatezile.days
                          Date.today <= data_expirare
                        else
                          false
                        end
                      end
                    else
                      false
                    end
                  else
                    false
                  end


                  @condition1 = if current_user
                    if current_user.role == 1
                      true
                    else
                      ComenziProd.joins(:prod) # Presupunând că 'prod' este numele corect al relației
                                .where(user_id: current_user.id, prods: { cod: ["cod11", "cod12", "cod13"] })
                                .exists?
                    end
                  else
                    false
                  end
    
    
    end
    
    
    
   
    if !current_user      
      @prods = Prod.where(curslegatura: 'Nutritie3', status: 'activ', cod: 'cod12')
    elsif current_user && @has_access
      @prods = Prod.none
      @platit=true # variabila care permite accesul la video
            if current_user && current_user.limba=='EN'
              @myvideo2 = Video.where(tip: 'nutritie3').where('ordine > ? AND ordine < ?', 4000, 5000).order(ordine: :asc)
            else  
              @myvideo2 = Video.where(tip: 'nutritie3').where('ordine <= ?', 1000).order(ordine: :asc)
            end  
      @myvideo7 = Video.where(tip: 'nutritie3').where('ordine > ? AND ordine < ?', 2000, 3000).order(ordine: :asc)#modulul 3
    elsif current_user && !@has_access && @condition1
      puts("saluuuuuut")
      @platit=false
      @prods = Prod.where(curslegatura: 'Nutritie3', status: 'activ', cod: 'cod38')
      @myvideo7 = Video.where(tip: 'nutritie3').where('ordine > ? AND ordine < ?', 2000, 3000).order(ordine: :asc)#modulul 3
    else
      @platit=false
      @prods = Prod.where(curslegatura: 'Nutritie3', status: 'activ', cod: 'cod12')
    end
    

  end
  
end
