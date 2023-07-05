class AddSursaToCursuris < ActiveRecord::Migration[7.0]
  def change
    add_column :cursuris, :sursa, :string
  end
end
