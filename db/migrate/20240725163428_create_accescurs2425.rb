class CreateAccescurs2425 < ActiveRecord::Migration[7.0]
  def change
    create_table :accescurs2425 do |t|
      t.integer :user_id
      t.boolean :septembrie, default: false
      t.boolean :octombrie, default: false
      t.boolean :noiembrie, default: false
      t.boolean :decembrie, default: false
      t.boolean :ianuarie, default: false
      t.boolean :februarie, default: false
      t.boolean :martie, default: false
      t.boolean :aprilie, default: false
      t.boolean :mai, default: false
      t.boolean :iunie, default: false
      t.boolean :iulie, default: false
      t.boolean :all, default: false
      t.boolean :all1, default: false
      t.boolean :septembrie1, default: false
      t.boolean :octombrie1, default: false
      t.boolean :noiembrie1, default: false
      t.boolean :decembrie1, default: false
      t.boolean :ianuarie1, default: false
      t.boolean :februarie1, default: false
      t.boolean :martie1, default: false
      t.boolean :aprilie1, default: false
      t.boolean :mai1, default: false
      t.boolean :iunie1, default: false
      t.boolean :iulie1, default: false

      t.timestamps
    end
  end
end

