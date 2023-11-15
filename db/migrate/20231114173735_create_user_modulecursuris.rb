class CreateUserModulecursuris < ActiveRecord::Migration[7.0]
  def change
    create_table :user_modulecursuris do |t|
      t.references :user, null: false, foreign_key: true
      t.references :modulecursuri, null: false, foreign_key: true
      t.string :validat

      t.timestamps
    end
  end
end
