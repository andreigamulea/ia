class AddTelefonAndPlatitToListacanal3 < ActiveRecord::Migration[7.0]
  def change
    add_column :listacanal3s, :telefon, :string
    add_column :listacanal3s, :platit, :string
  end
end
