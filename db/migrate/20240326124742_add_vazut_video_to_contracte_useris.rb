class AddVazutVideoToContracteUseris < ActiveRecord::Migration[7.0]
  def change
    add_column :contracte_useris, :vazut_video_ssm, :boolean, default: false
    add_column :contracte_useris, :vazut_video_isu, :boolean, default: false
  end
end
