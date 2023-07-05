class Prod < ApplicationRecord
    has_many :comenzi_prods
    has_many :comenzi, through: :comenzi_prods, source: :comanda
end
