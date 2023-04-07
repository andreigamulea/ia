class CreateListaproprietatis < ActiveRecord::Migration[7.0]
  def change
    create_table :listaproprietatis do |t|
      t.integer :idx
      t.string :proprietateter
      t.string :tipp
      t.integer :srota
      t.text :definire
      t.text :sinonime
      t.string :selectie
      t.integer :sel

      t.timestamps
    end
    add_index :listaproprietatis, :idx
    add_index :listaproprietatis, :proprietateter
    add_index :listaproprietatis, :srota
  end
end
