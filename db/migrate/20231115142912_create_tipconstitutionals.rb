class CreateTipconstitutionals < ActiveRecord::Migration[7.0]
  def change
    create_table :tipconstitutionals do |t|
      t.integer :nrtip
      t.integer :nr
      t.string :tip
      t.string :caracteristica

      t.timestamps
    end
  end
end
