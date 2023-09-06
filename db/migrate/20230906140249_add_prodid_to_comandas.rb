class AddProdidToComandas < ActiveRecord::Migration[7.0]
  def change
    add_column :comandas, :prodid, :integer
    add_index :comandas, :prodid

    add_column :comandas, :prodcod, :string
    add_index :comandas, :prodcod
  end
end
