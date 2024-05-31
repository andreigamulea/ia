class AddDetailsToFacturaproformas < ActiveRecord::Migration[7.0]
  def change
    add_column :facturaproformas, :serie_factura, :string
    add_column :facturaproformas, :plata_prin, :string
    add_column :facturaproformas, :data_platii, :date
  end
end
