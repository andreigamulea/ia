class AddStatusToFacturas < ActiveRecord::Migration[7.0]
  def change
    add_column :facturas, :status, :string
    add_index :facturas, :status
  end
end

