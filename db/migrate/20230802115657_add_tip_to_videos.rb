class AddTipToVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :tip, :string
  end
end
