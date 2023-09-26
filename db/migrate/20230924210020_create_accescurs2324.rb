class CreateAccescurs2324 < ActiveRecord::Migration[7.0]
  def change
    create_table :accescurs2324s do |t|
      t.integer :user_id
      t.boolean :septembrie
      t.boolean :octombrie
      t.boolean :noiembrie
      t.boolean :decembrie
      t.boolean :ianuarie
      t.boolean :februarie
      t.boolean :martie
      t.boolean :aprilie
      t.boolean :mai
      t.boolean :iunie
      t.boolean :iulie

      t.timestamps
    end
  end
end
