class AddTelefonFieldsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :telefon, :string
    add_column :users, :telefon2, :string
    add_column :users, :telefon3, :string
  end
end
