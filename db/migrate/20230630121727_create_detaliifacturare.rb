class CreateDetaliifacturare < ActiveRecord::Migration[7.0]
  def change
    create_table :detaliifacturares do |t|
      t.integer :user_id
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

      t.timestamps
    end
  end
end
