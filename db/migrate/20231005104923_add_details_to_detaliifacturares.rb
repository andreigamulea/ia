class AddDetailsToDetaliifacturares < ActiveRecord::Migration[7.0]
  def change
    add_column :detaliifacturares, :prenume1, :string
    add_column :detaliifacturares, :nume1, :string
    add_column :detaliifacturares, :numecompanie1, :string
    add_column :detaliifacturares, :tara1, :string
    add_column :detaliifacturares, :codpostal1, :string
    add_column :detaliifacturares, :strada1, :string
    add_column :detaliifacturares, :numar1, :string
    add_column :detaliifacturares, :localitate1, :string
    add_column :detaliifacturares, :judet1, :string
    add_column :detaliifacturares, :altedate1, :text
    add_column :detaliifacturares, :telefon1, :string
    add_column :detaliifacturares, :use_alternate_shipping, :boolean, default: false
  end
end
