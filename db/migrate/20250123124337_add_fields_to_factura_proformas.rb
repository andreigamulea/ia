class AddFieldsToFacturaProformas < ActiveRecord::Migration[7.1]
  def change
    add_column :facturaproformas, :cnp, :string
    add_column :facturaproformas, :abr_jud, :string
    add_column :facturaproformas, :abr_tara, :string
  end
end
