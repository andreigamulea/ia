class Nutritie3Controller < ApplicationController
    def index
        @myvideo = Video.where(tip: 'nutritie3').order(ordine: :asc)
    end
end
