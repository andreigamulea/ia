class AddTaxa2324ToComenziProds < ActiveRecord::Migration[7.0]
  def change
    add_column :comenzi_prods, :taxa2324, :integer
    add_index :comenzi_prods, :taxa2324
  end
end
