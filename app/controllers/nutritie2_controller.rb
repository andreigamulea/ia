class Nutritie2Controller < ApplicationController
  def index
    @has_access = current_user&.role == 1 || (current_user&.role == 0 && current_user.nutritieabsolvit == 2)

      if @has_access
        @myvideo4 = Video.where(tip: 'nutritie2').where('ordine > ? AND ordine < ?', 3000, 4000).order(ordine: :asc)

      end  

  end
end
