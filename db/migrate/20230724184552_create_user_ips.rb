class CreateUserIps < ActiveRecord::Migration[7.0]
  def change
    create_table :user_ips do |t|
      t.references :user, null: false, foreign_key: true
      t.string :ip_address
      t.string :curspromo

      t.timestamps
    end
  end
end
