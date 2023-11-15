class Nutritie1Controller < ApplicationController
  def index
    
    if current_user
      has_module_1 = UserModulecursuri.exists?(user_id: current_user.id, 
                                               modulecursuri_id: 1, 
                                               validat: "Finalizata")
    
      has_module_2 = UserModulecursuri.exists?(user_id: current_user.id, 
                                               modulecursuri_id: 2, 
                                               validat: "Finalizata")
    
      # Setează @has_access pe true dacă utilizatorul are ambele modulecursuri_id: 1 și 2,
      # sau dacă rolul utilizatorului curent este 1
      @has_access = (has_module_1 && has_module_2) || current_user.role == 1
    
      # Setează @has_access1 pe true doar dacă utilizatorul are modulecursuri_id: 1 
      # și nu are modulecursuri_id: 2
      @has_access1 = has_module_1 && !has_module_2
    end
    
    
    if @has_access #@myvideo4  este pentru cei care au platit tot nutritie1 p1+p2 - vor avea acces pana la curs 8b
      #voi nota videourile 5,6,7,8 de la 2001 in sus
      @myvideo4 = Video.where(tip: 'nutritie1').where('ordine > ? AND ordine < ?', 1000, 3000).order(ordine: :asc)  
    end  
    if @has_access1  #@myvideo3  este pentru cei care au platit doar nutritie1 p1 - vor avea acces pana la curs 4b
      @myvideo3 = Video.where(tip: 'nutritie1').where('ordine > ? AND ordine < ?', 1000, 2000).order(ordine: :asc)  
    end  
  end
end

