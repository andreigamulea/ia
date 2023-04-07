class CreateListacursuris < ActiveRecord::Migration[7.0]
  def change
    create_table :listacursuris do |t|
      t.string :nume

      t.timestamps
    end
  end
end
