class AddIndexAndForeignKeyToAccescurs2324s < ActiveRecord::Migration[7.0]
  def change
    add_index :accescurs2324s, :user_id
    add_foreign_key :accescurs2324s, :users
  end
end
