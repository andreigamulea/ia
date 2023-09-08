class AddUserIdToComenziProds < ActiveRecord::Migration[7.0]
  def change
    add_column :comenzi_prods, :user_id, :integer
    add_index :comenzi_prods, :user_id
  end
end

