class CreateSrota < ActiveRecord::Migration[7.0]
  def change
    create_table :srota do |t|
      t.integer :codsrota
      t.integer :codsr
      t.string :numesrota
      t.string :numescurt
      t.string :explicatie
      t.string :origine
      t.string :parti
      t.string :functii
      t.string :observatie

      t.timestamps
    end
    add_index :srota, :codsrota
    add_index :srota, :codsr
  end
end
