class Modulecursuri < ApplicationRecord
    has_many :user_modulecursuris
    has_many :users, through: :user_modulecursuris
end
