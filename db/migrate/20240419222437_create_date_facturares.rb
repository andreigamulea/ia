class CreateDateFacturares < ActiveRecord::Migration[7.0]
  def change
    create_table :date_facturares do |t|
      t.integer :user_id
      t.integer :firma_id
      t.string :email
      t.string :prenume
      t.string :nume
      t.string :numecompanie
      t.string :cui
      t.string :tara
      t.string :codpostal
      t.string :strada
      t.string :numar
      t.text :altedate
      t.string :telefon
      t.string :adresaemail
      t.string :localitate
      t.string :judet
      t.string :grupa2324
      t.string :cpa

      t.timestamps
    end
  end
end
