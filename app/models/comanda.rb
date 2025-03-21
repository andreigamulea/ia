class Comanda < ApplicationRecord
    has_many :comenzi_prods, dependent: :destroy
    has_many :prods, through: :comenzi_prods, source: :prod
    belongs_to :user
    has_one :adresa_comenzi, class_name: 'AdresaComenzi'
    has_one :facturaproforma
  end
  