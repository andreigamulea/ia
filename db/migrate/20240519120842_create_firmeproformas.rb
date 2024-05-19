class CreateFirmeproformas < ActiveRecord::Migration[7.0]
  def change
    create_table :firmeproformas do |t|
      t.string :nume_institutie
      t.string :cui
      t.string :rc
      t.string :adresa
      t.string :banca
      t.string :cont
      t.string :serie
      t.string :nrinceput
      t.string :tva
      t.string :cod

      t.timestamps
    end
  end
end
