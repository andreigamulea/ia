class CreateImportanta < ActiveRecord::Migration[7.0]
  def change
    create_table :importanta do |t|
      t.integer :codimp
      t.string :grad
      t.string :descgrad

      t.timestamps
    end
  end
end
