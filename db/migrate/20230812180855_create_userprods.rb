class CreateUserprods < ActiveRecord::Migration[7.0]
  def change
    create_table :userprods do |t|
      t.references :user, null: false, foreign_key: true
      t.references :prod, null: false, foreign_key: true

      t.timestamps
    end
  end
end
