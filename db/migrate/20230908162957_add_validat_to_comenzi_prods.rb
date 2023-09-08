class AddValidatToComenziProds < ActiveRecord::Migration[7.0]
  def change
    add_column :comenzi_prods, :validat, :string
    add_index :comenzi_prods, :validat
  end
end
