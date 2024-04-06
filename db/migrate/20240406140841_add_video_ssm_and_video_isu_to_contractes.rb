class AddVideoSsmAndVideoIsuToContractes < ActiveRecord::Migration[7.0]
  def change
    add_column :contractes, :video_ssm, :string
    add_column :contractes, :video_isu, :string
  end
end
