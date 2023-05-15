class Paginisite < ApplicationRecord
    has_many :userpaginisite
    has_many :users, through: :userpaginisite
end
