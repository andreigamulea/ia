class AddLinkpdfToVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :linkpdf, :string
  end
end
