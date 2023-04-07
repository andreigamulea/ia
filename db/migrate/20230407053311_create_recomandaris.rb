class CreateRecomandaris < ActiveRecord::Migration[7.0]
  def change
    create_table :recomandaris do |t|
      t.integer :listaproprietati_id
      t.integer :idpr
      t.integer :idp
      t.integer :idpp
      t.string :imp
      t.string :tipp
      t.integer :srota
      t.string :proprietate
      t.string :propeng
      t.string :propayur
      t.string :propgerm
      t.string :completari
      t.string :sursa
      t.string :sel

      t.timestamps
    end
    add_index :recomandaris, :listaproprietati_id
    add_index :recomandaris, :idpp
    add_index :recomandaris, :srota
  end
end
