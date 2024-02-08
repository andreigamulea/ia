class AddDetailsToComenziProds < ActiveRecord::Migration[7.0]
  def change
    add_column :comenzi_prods, :cantitate, :integer
    add_column :comenzi_prods, :pret_bucata, :decimal, precision: 10, scale: 2
    add_column :comenzi_prods, :pret_total, :decimal, precision: 10, scale: 2
  end
end
