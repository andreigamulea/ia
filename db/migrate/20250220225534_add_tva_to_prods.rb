class AddTvaToProds < ActiveRecord::Migration[7.1]
  def change
    add_column :prods, :tva, :decimal
  end
end
