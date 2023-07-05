class CreateComandas < ActiveRecord::Migration[7.0]
  def change
    create_table :comandas do |t|
      t.date :datacomenzii
      t.integer :numar
      t.string :statecomanda1
      t.string :statecomanda2
      t.string :stateplata1
      t.string :stateplata2
      t.string :stateplata3
      t.integer :user_id
      t.string :emailcurrent
      t.string :emailplata
      t.decimal :total
      t.string :plataprin

      t.timestamps
    end
  end
end
