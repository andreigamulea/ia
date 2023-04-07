class Listacursuri < ApplicationRecord
    has_many :cursuri
    has_many :users, through: :cursuri
end
