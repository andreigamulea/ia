class Prod < ApplicationRecord
    has_many :comenzi_prods
    has_many :comenzi, through: :comenzi_prods, source: :comanda
    has_many :userprods
    has_many :users, through: :userprods
end
