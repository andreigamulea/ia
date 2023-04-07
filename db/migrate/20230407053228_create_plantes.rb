class CreatePlantes < ActiveRecord::Migration[7.0]
  def change
    create_table :plantes do |t|
      t.integer :idp
      t.string :tip
      t.string :subt
      t.string :nume
      t.string :denbot
      t.string :numesec
      t.string :numesec2
      t.string :numeayu
      t.string :fam

      t.timestamps
    end
    add_index :plantes, :idp, unique: true
    add_index :plantes, :nume, unique: true
  end
end
