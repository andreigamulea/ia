class CreateAn32324s < ActiveRecord::Migration[7.0]
  def change
    create_table :an32324s do |t|
      t.string :email
      t.string :nume
      t.string :telefon
      t.string :sep
      t.string :oct
      t.string :nov
      t.string :dec
      t.string :ian
      t.string :feb
      t.string :mar
      t.string :apr
      t.string :mai
      t.string :iun
      t.string :iul
      t.string :pret

      t.timestamps
    end
  end
end
