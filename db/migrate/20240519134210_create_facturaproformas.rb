class CreateFacturaproformas < ActiveRecord::Migration[7.0]
  def change
    create_table :facturaproformas do |t|
      t.references :comanda, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :prod, null: false, foreign_key: true
      t.string :numar_factura
      t.string :numar_comanda
      t.date :data_emiterii
      t.string :prenume
      t.string :nume
      t.string :nume_companie
      t.string :cui
      t.string :tara
      t.string :localitate
      t.string :judet
      t.string :strada
      t.string :numar_adresa
      t.string :cod_postal
      t.string :altedate
      t.string :telefon
      t.string :produs
      t.integer :cantitate
      t.decimal :pret_unitar
      t.decimal :valoare_tva
      t.decimal :valoare_totala
      t.string :cod_firma
      t.string :status

      t.timestamps
    end
  end
end
