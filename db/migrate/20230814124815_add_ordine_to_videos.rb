class AddOrdineToVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :ordine, :integer
  end
end
