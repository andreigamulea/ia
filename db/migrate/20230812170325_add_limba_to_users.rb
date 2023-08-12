class AddLimbaToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :limba, :string
    add_index :users, :limba
  end
end
