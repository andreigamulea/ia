class CreateTvs < ActiveRecord::Migration[7.0]
  def change
    create_table :tvs do |t|
      t.string :denumire
      t.string :link
      t.string :cine
      t.integer :canal
      t.date :datainceput
      t.time :orainceput
      t.integer :mininceput
      t.date :datasfarsit
      t.time :orasfarsit
      t.integer :minsfarsit
      t.integer :user_id
      t.string :referinta

      t.timestamps
    end
  end
end
