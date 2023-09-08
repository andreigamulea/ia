class CreateUserVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :user_videos do |t|

      t.timestamps
    end
  end
end
