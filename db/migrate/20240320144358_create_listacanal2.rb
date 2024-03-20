class CreateListacanal2 < ActiveRecord::Migration[7.0]
  def change
    create_table :listacanal2s do |t|
      t.string :email
      t.string :nume

      t.timestamps
    end
  end
end
