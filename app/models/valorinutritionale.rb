class Valorinutritionale < ApplicationRecord
    def self.ransackable_attributes(auth_object = nil)
        ["aliment", "calorii", "carbohidrati", "cod", "created_at", "fibre", "id", "id_value", "lipide", "observatii", "proteine", "updated_at"]
      end
end
