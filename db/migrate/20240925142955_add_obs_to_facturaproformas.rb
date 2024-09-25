class AddObsToFacturaproformas < ActiveRecord::Migration[7.1]
  def change
    add_column :facturaproformas, :obs, :string
  end
end
