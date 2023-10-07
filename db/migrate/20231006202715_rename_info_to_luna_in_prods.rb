class RenameInfoToLunaInProds < ActiveRecord::Migration[7.0]
  def change
    rename_column :prods, :info, :luna
    change_column :prods, :luna, :string
  end
end
