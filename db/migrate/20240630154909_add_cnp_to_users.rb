class AddCnpToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :cnp, :string
  end
end
