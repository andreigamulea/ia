class CreatePlantePartis < ActiveRecord::Migration[7.0]
  def change
    create_table :plante_partis do |t|
      t.integer :idx
      t.integer :cpl
      t.string :parte
      t.string :part
      t.string :clasa
      t.string :invpp
      t.string :tippp
      t.string :recomandari
      t.string :textsursa
      t.string :starereprez
      t.string :z
      t.string :healthrel
      t.string :compozitie
      t.string :etich
      t.string :healthrelrom
      t.string :propspeciale
      t.string :selectie
      t.string :lucru
      t.string :s
      t.string :sel
      t.integer :index2
      t.string :ordvol
      t.string :selpz
      t.string :selpzn
      t.string :sels
      t.string :selz
      t.string :selnr
      t.string :t10
      t.string :t11
      t.string :t12
      t.string :t13
      t.string :t14
      t.string :t15
      t.string :t16
      t.string :b
      t.string :r
      t.string :c
      t.string :imp
      t.string :testat
      t.string :g1
      t.string :g2
      t.string :g3
      t.string :g4
      t.string :g5
      t.string :g6
      t.string :vir
      t.string :vip
      t.string :imaginepp

      t.timestamps
    end
    add_index :plante_partis, :idx
    add_index :plante_partis, :cpl
    add_index :plante_partis, :index2
  end
end
