class CreateCursuriHistory < ActiveRecord::Migration[7.0]
  def change
    create_table :cursuri_history do |t|
      t.references :user, null: false, foreign_key: true
      t.references :listacursuri, null: false, foreign_key: true
      t.integer :cursuri_id, null: false
      t.date :datainceput, null: true
      t.date :datasfarsit, null: true
      t.timestamps
    end
  end
end
