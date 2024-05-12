class Factura < ApplicationRecord
  belongs_to :comanda
  belongs_to :user
 
end
