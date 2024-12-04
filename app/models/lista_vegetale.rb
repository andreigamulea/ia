class ListaVegetale < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "dataa", "id", "id_value", "mentiunirestrictii", "numar", "parteutilizata", "sinonime", "specie", "stadiu", "updated_at"]
  end
end

