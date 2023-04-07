class CreateTipuriProps < ActiveRecord::Migration[7.0]
  def change
    create_table :tipuri_props do |t|
      t.integer :idxcp
      t.string :cp
      t.string :explicatie

      t.timestamps
    end
  end
end
