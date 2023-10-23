class AddNutritieabsolvitToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :nutritieabsolvit, :float
  end
end
