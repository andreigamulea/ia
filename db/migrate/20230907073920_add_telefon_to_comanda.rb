class AddTelefonToComanda < ActiveRecord::Migration[7.0]
  def change
    add_column :comandas, :telefon, :string
  end
end
