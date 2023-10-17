class Nutritie3Controller < ApplicationController
  def index
    @myvideo = Video.where(tip: 'nutritie3').where('ordine <= ?', 1000).order(ordine: :asc)
  
    # Logic for @has_access
    @has_access = if current_user.role == 1
                    true
                  elsif current_user.role == 0
                    ComenziProd.joins(:prod).where(user_id: current_user.id, prods: { cod: "cod12" }).exists? ||
                    (ComenziProd.joins(:prod).where(user_id: current_user.id, prods: { cod: "cod11" }).exists? && 
                     ComenziProd.joins(:prod).where(user_id: current_user.id, prods: { cod: "cod38" }).exists?) ||
                    (ComenziProd.joins(:prod).where(user_id: current_user.id, prods: { cod: "cod13" }).exists? && 
                     ComenziProd.joins(:prod).where(user_id: current_user.id, prods: { cod: "cod39" }).exists?)
                  else
                    false
                  end
    
                  @has_access1 = if current_user.role == 0
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
      coduri_din_video = Video.where(tip: 'nutritie3').where('ordine < ?', 1000).pluck(:cod)

      # Calculează intersecția între codurile plătite și cele relevante
      relevant_cod_values = paid_cod_values & coduri_din_video
      @am_video=relevant_cod_values
      

      @myvideo2 = Video.where(tip: 'nutritie3', cod: relevant_cod_values)
    end
  
    @myvideo1 = Video.where(tip: 'nutritie3').where('ordine > ?', 1000).order(ordine: :asc)
  end
  
end
