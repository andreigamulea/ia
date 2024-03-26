class AddTelefonAndPlatitToListacanal2 < ActiveRecord::Migration[7.0]
  def change
    add_column :listacanal2s, :telefon, :string
    add_column :listacanal2s, :platit, :string
  end
end
