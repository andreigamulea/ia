class AddGrupa2425ToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :grupa2425, :integer
  end
end
