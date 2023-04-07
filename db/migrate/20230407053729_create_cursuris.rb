class CreateCursuris < ActiveRecord::Migration[7.0]
  def change
    create_table :cursuris do |t|
      t.string :numecurs
      t.date :datainceput
      t.date :datasfarsit
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
