class AddStatusToProds < ActiveRecord::Migration[7.0]
  def change
    add_column :prods, :status, :string
  end
end
