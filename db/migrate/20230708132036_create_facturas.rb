class CreateFacturas < ActiveRecord::Migration[7.0]
  def change
    create_table :facturas do |t|
      t.references :comanda, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :numar
      t.integer :numar_comanda
      t.date :data_emiterii
      t.string :prenume
      t.string :nume
      t.string :nume_companie
      t.string :cui
      t.string :tara
      t.string :localitate
      t.string :judet
      t.string :cod_postal
      t.string :strada
      t.string :numar_adresa
      t.string :produs
      t.integer :cantitate
      t.decimal :pret_unitar
      t.decimal :valoare_tva
      t.decimal :valoare_totala

      t.timestamps
    end
  end
end
