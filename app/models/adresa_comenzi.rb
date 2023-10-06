class AdresaComenzi < ApplicationRecord
    self.table_name = "adresacomenzi"
    belongs_to :comanda
  end
  