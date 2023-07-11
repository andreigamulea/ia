class Comanda < ApplicationRecord
    has_many :comenzi_prods, dependent: :destroy
    has_many :prods, through: :comenzi_prods, source: :prod
    belongs_to :user
  end
  