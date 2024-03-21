class Tv < ApplicationRecord
    validates :denumire, :link, :cine, :canal, :datainceput, :orainceput, :datasfarsit, :orasfarsit, :user_id,  presence: true
end
