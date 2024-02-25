class CreateNewsletters < ActiveRecord::Migration[7.0]
  def change
    create_table :newsletters do |t|
      t.string :nume
      t.string :email
      t.boolean :valid

      t.timestamps
    end
  end
end
