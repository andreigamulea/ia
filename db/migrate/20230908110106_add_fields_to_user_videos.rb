class AddFieldsToUserVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :user_videos, :datainceput, :datetime
    add_column :user_videos, :datasfarsit, :datetime
    add_column :user_videos, :nume, :string
    add_column :user_videos, :tip, :string
  end
end
