class Facturaproforma < ApplicationRecord
  belongs_to :comanda
  belongs_to :user
  belongs_to :prod
  validates :serie_factura, presence: true
end
