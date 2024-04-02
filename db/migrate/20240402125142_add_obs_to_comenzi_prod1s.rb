class AddObsToComenziProd1s < ActiveRecord::Migration[7.0]
  def change
    add_column :comenzi_prod1s, :obs, :string
  end
end
