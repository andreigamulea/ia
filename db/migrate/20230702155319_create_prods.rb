class CreateProds < ActiveRecord::Migration[7.0]
  def change
    create_table :prods do |t|
      t.string :nume
      t.text :detalii
      t.text :info
      t.decimal :pret
      t.integer :valabilitatezile
      t.string :curslegatura

      t.timestamps
    end
  end
end
