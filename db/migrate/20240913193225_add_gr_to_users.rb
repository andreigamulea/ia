class AddGrToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :gr, :jsonb, default: {}, null: false
  end
end