class AddLunaToVideo < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :luna, :string
    add_index :videos, :luna
  end
end
