class Nutritie4Controller < ApplicationController
  def index 
    #am copiat codul care functiona de la N3 in Nutritie4Controller si in VideosController la set_user12... _video1... nutritie4.html.erb
    #acum trebuie adaptat pt N4
    ###################################################### cod de la servicii
    special_prod_id = 9
    another_special_prod_id = 11

    if current_user && current_user.role == 1
      @prods = Prod.order(:id).to_a
    else
      @prods = Prod.where(status: 'activ').where.not(id: [special_prod_id, another_special_prod_id, 12]).order(:id).to_a

    end
  
    if params[:payment] == "success"
      flash[:notice] = "Plata a fost efectuată cu succes!"
    end
  
    # Verifică dacă utilizatorul curent există în Userprod cu prod_id special_prod_id și adaugă produsul la lista de afișat
    if current_user
      if Userprod.exists?(user_id: current_user.id, prod_id: another_special_prod_id)
        # Dacă utilizatorul are acces la produsul cu ID-ul 11
        if !@prods.find { |prod| prod.id == another_special_prod_id }
          another_special_prod = Prod.find(another_special_prod_id)
          @prods << another_special_prod
        end
        
        # Dă-le și acces la produsul cu ID-ul 12
        if !@prods.find { |prod| prod.id == 12 }
          prod_12 = Prod.find(12)
          @prods << prod_12
        end
      end
    
      # Logica pentru produsul special cu ID-ul 9 (ca mai înainte)
      if Userprod.exists?(user_id: current_user.id, prod_id: special_prod_id) && !@prods.find { |prod| prod.id == special_prod_id }
        special_prod = Prod.find(special_prod_id)
        @prods << special_prod
      end
    end
    #@prod_tayt12 = Prod.where(curslegatura: 'tayt12')
    #@prod_tayt12 = Prod.where(curslegatura: 'tayt12').order(:cod)
    @prod_tayt12 = Prod.where(curslegatura: 'tayt12', status: 'activ').order(:cod)


    #startvariabilele pt nutritie3
    @prod_id_cod11 = Prod.find_by(cod: 'cod11')&.id
    @prod_id_cod13 = Prod.find_by(cod: 'cod13')&.id
    
   

    if current_user
      @user_has_prod_cod11 = ComenziProd.exists?(user_id: current_user.id, prod_id: @prod_id_cod11, validat: 'Finalizata')
      @user_has_prod_cod13 = ComenziProd.exists?(user_id: current_user.id, prod_id: @prod_id_cod13, validat: 'Finalizata')    
      @user_has_bought_cod11_or_cod13 = @user_has_prod_cod11 || @user_has_prod_cod13
    else
      @user_has_prod_cod11 = false
      @user_has_prod_cod13 = false
      @user_has_bought_cod11_or_cod13 = false
    end
    
    
    
    #stoptvariabilele pt nutritie3
    ######################################################
    if current_user && current_user.limba=='EN'
    @myvideo = Video.where(tip: 'nutritie3').where('ordine > ? AND ordine < ?', 4000, 5000).order(ordine: :asc)
    else  
    @myvideo = Video.where(tip: 'nutritie3').where('ordine <= ?', 1000).order(ordine: :asc)
    end  
    # Logic for @has_access
    @has_access = if current_user && current_user.role == 1
                    true
                  elsif current_user && current_user.role == 0
                    ComenziProd.joins(:prod).where(user_id: current_user.id, prods: { cod: "cod12" }).exists? ||
                    (ComenziProd.joins(:prod).where(user_id: current_user.id, prods: { cod: "cod11" }).exists? && 
                     ComenziProd.joins(:prod).where(user_id: current_user.id, prods: { cod: "cod38" }).exists?) ||
                    (ComenziProd.joins(:prod).where(user_id: current_user.id, prods: { cod: "cod13" }).exists? && 
                     ComenziProd.joins(:prod).where(user_id: current_user.id, prods: { cod: "cod39" }).exists?)
                  else
                    false
                  end
    
                  @has_access1 = if current_user && current_user.role == 0
                    (ComenziProd.joins(:prod).where(user_id: current_user.id, prods: { cod: "cod11" }).exists? && 
                     !ComenziProd.joins(:prod).where(user_id: current_user.id, prods: { cod: ["cod38", "cod39"] }).exists?) ||
                    (ComenziProd.joins(:prod).where(user_id: current_user.id, prods: { cod: "cod13" }).exists? && 
                     !ComenziProd.joins(:prod).where(user_id: current_user.id, prods: { cod: ["cod38", "cod39"] }).exists?)
                  else
                    false
                  end
  
      # Logic for @myvideo2
    if current_user && @has_access1
      # Get the cod values from the Prod model based on the user's purchases
      puts("da are acces1")
      paid_cod_values = ComenziProd.joins(:prod).where(user_id: current_user.id).where('comenzi_prods.datasfarsit >= ?', Date.today).pluck("prods.cod").uniq
      puts("paid_cod_values: #{paid_cod_values}")
      puts("da are acces2")
      

      # Filter videos based on the paid cod values
      # Preia codurile relevante din tabela `Video`
      if current_user && current_user.limba=='EN'    
        puts("da are acces3")   
        
        coduri_din_video = Video.where(tip: 'nutritie3').where('ordine > ? AND ordine < ?', 4000, 5000).order(ordine: :asc).pluck(:cod)
        puts("coduri_din_video: #{coduri_din_video}") 
      else  
        puts("da are acces4")  
        coduri_din_video = Video.where(tip: 'nutritie3').where('ordine < ?', 1000).pluck(:cod)
        puts("coduri_din_video: #{coduri_din_video}") 
        puts("da are acces5")
      end  
      # Calculează intersecția între codurile plătite și cele relevante
      relevant_cod_values = paid_cod_values & coduri_din_video
      @am_video=relevant_cod_values
      

      @myvideo2 = Video.where(tip: 'nutritie3', cod: relevant_cod_values)
    end
  
    @myvideo1 = Video.where(tip: 'nutritie3').where('ordine > ? AND ordine < ?', 1000, 2000).order(ordine: :asc)#Aspecte organizatorice
    #o sa pun la Resurse intre 2000-3000 video ce tin de modul 3 iar intre 3000-4000 video ce tin de modul 2
    if (current_user && current_user.role==1) || (current_user && current_user.nutritieabsolvit==2)
      @myvideo4 = Video.where(tip: 'nutritie3').where('ordine > ? AND ordine < ?', 2000, 3000).
      order(Arel.sql("CASE WHEN tip = 'nutritie2' THEN 1 ELSE 2 END, ordine ASC"))#modulul 2 si 3
    else      
      @myvideo4 = Video.where(tip: 'nutritie3').where('ordine > ? AND ordine < ?', 2000, 3000).order(ordine: :asc)#modulul 3
    end  
      
    

  end
  
end
