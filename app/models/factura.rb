class Factura < ApplicationRecord
  belongs_to :comanda
  belongs_to :user
  def self.achitata
    Factura.where("status IS NULL OR status != ?", "anulata").update_all(status: 'Achitata')
  end
end
