class CreateDescriereerori < ActiveRecord::Migration[7.0]
  def change
    create_table :descriereeroris do |t|
      t.text :descriere

      t.timestamps
    end
  end
end
