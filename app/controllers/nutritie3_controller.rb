class Nutritie3Controller < ApplicationController
    def index
      @myvideo = Video.where(tip: 'nutritie3').where('ordine <= ?', 1000).order(ordine: :asc)      #aici am cursurile
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
          @myvideo1 = Video.where(tip: 'nutritie3').where('ordine > ?', 1000).order(ordine: :asc)

    end
end
