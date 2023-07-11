class AddGdprToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :gdpr, :boolean, default: false
  end
end
