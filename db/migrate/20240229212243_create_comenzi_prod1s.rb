class CreateComenziProd1s < ActiveRecord::Migration[7.0]
  def change
    create_table :comenzi_prod1s do |t|
      t.bigint :prod_id
      t.bigint :user_id
      t.date :datainceput
      t.date :datasfarsit
      t.string :validat
      t.integer :taxa2324
      t.integer :cantitate
      t.decimal :pret_bucata, precision: 10, scale: 2
      t.decimal :pret_total, precision: 10, scale: 2
      t.bigint :comanda_id

      t.timestamps
    end
  end
end
