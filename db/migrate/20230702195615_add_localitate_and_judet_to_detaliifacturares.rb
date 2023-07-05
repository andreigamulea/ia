class AddLocalitateAndJudetToDetaliifacturares < ActiveRecord::Migration[7.0]
  def change
    add_column :detaliifacturares, :localitate, :string
    add_column :detaliifacturares, :judet, :string
  end
end
