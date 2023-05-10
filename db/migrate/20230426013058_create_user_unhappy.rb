class CreateUserUnhappy < ActiveRecord::Migration[7.0]
  def change
    create_table :user_unhappies do |t|
      t.integer :user_id
      t.string :name
      t.string :email
      t.integer :role

      t.timestamps
    end
  end
end
