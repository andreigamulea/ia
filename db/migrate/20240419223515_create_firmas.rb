class CreateFirmas < ActiveRecord::Migration[7.0]
  def change
    create_table :firmas do |t|
      t.string :nume_institutie
      t.string :cui
      t.string :rc
      t.string :adresa
      t.string :banca
      t.string :cont
      t.string :serie
      t.integer :nrinceput

      t.timestamps
    end
  end
end
