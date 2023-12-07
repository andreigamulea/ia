class CreateContractes < ActiveRecord::Migration[7.0]
  def change
    create_table :contractes do |t|
      t.integer :user_id
      t.string :email
      t.string :tip
      t.string :denumire
      t.integer :contor
      t.text :textcontract

      t.timestamps
    end
  end
end
