class CreateAdresacomenzi < ActiveRecord::Migration[7.0]
  def change
    create_table :adresacomenzi do |t|
      t.integer :comanda_id
      t.boolean :adresacoincide, default: false
      t.string :prenume
      t.string :nume
      t.string :numecompanie
      t.string :cui
      t.string :tara
      t.string :judet
      t.string :localitate
      t.string :codpostal
      t.string :strada
      t.string :numar
      t.text :altedate
      t.string :telefon
      t.string :email
  
      t.timestamps
    end
  
    # Adaugă un index pe coloana comanda_id pentru performanță
    add_index :adresacomenzi, :comanda_id
  end
  
end
