class AddObsToComenziProds < ActiveRecord::Migration[7.0]
  def change
    add_column :comenzi_prods, :obs, :string
  end
end
