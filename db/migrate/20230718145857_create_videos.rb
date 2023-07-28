class CreateVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :videos do |t|
      t.string :nume
      t.text :descriere
      t.string :sursa
      t.string :link

      t.timestamps
    end
  end
end
