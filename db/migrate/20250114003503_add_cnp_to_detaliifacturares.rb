class AddCnpToDetaliifacturares < ActiveRecord::Migration[7.1]
  def change
    add_column :detaliifacturares, :cnp, :integer
  end
end
