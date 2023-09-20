class AddGrupaToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :grupa, :integer
    add_index :users, :grupa
  end
end
