class Nutritie3Controller < ApplicationController
  def index
    if !current_user
      redirect_to new_user_session_path and return
    end
    if current_user.limba=='EN'
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
    if @has_access1
      # Get the cod values from the Prod model based on the user's purchases
      
      paid_cod_values = ComenziProd.joins(:prod).where(user_id: current_user.id).where('comenzi_prods.datasfarsit >= ?', Date.today).pluck("prods.cod").uniq

      

      # Filter videos based on the paid cod values
      # Preia codurile relevante din tabela `Video`
      if current_user && current_user.limba=='EN'       
        coduri_din_video = Video.where(tip: 'nutritie3').where('ordine > ? AND ordine < ?', 4000, 5000).order(ordine: :asc)
      else  
        coduri_din_video = Video.where(tip: 'nutritie3').where('ordine < ?', 1000).pluck(:cod)
      end  
      # Calculează intersecția între codurile plătite și cele relevante
      relevant_cod_values = paid_cod_values & coduri_din_video
      @am_video=relevant_cod_values
      

      @myvideo2 = Video.where(tip: 'nutritie3', cod: relevant_cod_values)
    end
  
    @myvideo1 = Video.where(tip: 'nutritie3').where('ordine > ? AND ordine < ?', 1000, 2000).order(ordine: :asc)#Aspecte organizatorice
    #o sa pun la Resurse intre 2000-3000 video ce tin de modul 3 iar intre 3000-4000 video ce tin de modul 2
    if (current_user && current_user.role==1) || (current_user && current_user.nutritieabsolvit==2)
      @myvideo4 = Video.where(tip: 'nutritie3').where('ordine > ? AND ordine < ?', 2000, 3000)
                 .or(Video.where(tip: 'nutritie2').where('ordine > ? AND ordine < ?', 3000, 4000))
                 .order(Arel.sql("CASE WHEN tip = 'nutritie2' THEN 1 ELSE 2 END, ordine ASC"))#modulul 2 si 3
    else      
      @myvideo4 = Video.where(tip: 'nutritie3').where('ordine > ? AND ordine < ?', 2000, 3000).order(ordine: :asc)#modulul 3
    end  
      
    

  end
  
end
