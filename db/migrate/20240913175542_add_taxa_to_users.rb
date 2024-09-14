class AddTaxaToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :taxa, :jsonb, default: {}, null: false
  end
end
