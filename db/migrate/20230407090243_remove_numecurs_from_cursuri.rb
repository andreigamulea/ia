class RemoveNumecursFromCursuri < ActiveRecord::Migration[7.0]
  def change
    remove_column :cursuris, :numecurs, :string
  end
end
