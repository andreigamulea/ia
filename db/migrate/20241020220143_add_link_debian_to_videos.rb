class AddLinkDebianToVideos < ActiveRecord::Migration[7.1]
  def change
    add_column :videos, :link_debian, :string
  end
end
