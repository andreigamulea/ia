class CreateComenziProds < ActiveRecord::Migration[7.0]
  def change
    create_table :comenzi_prods do |t|
      t.references :prod, null: false, foreign_key: true
      t.references :comanda, null: false, foreign_key: true
      t.date :datainceput
      t.date :datasfarsit

      t.timestamps
    end
  end
end
