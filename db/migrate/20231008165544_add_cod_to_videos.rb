class AddCodToVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :cod, :string
  end
end
