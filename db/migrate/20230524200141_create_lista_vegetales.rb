class CreateListaVegetales < ActiveRecord::Migration[7.0]
  def change
    create_table :lista_vegetales do |t|
      t.string :specie
      t.string :sinonime
      t.string :parteutilizata
      t.string :mentiunirestrictii

      t.timestamps
    end

    add_index :lista_vegetales, :specie
    add_index :lista_vegetales, :sinonime
    add_index :lista_vegetales, :parteutilizata
    add_index :lista_vegetales, :mentiunirestrictii
  end
end
