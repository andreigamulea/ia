class RemoveValidFromNewsletters < ActiveRecord::Migration[7.0]
  def change
    remove_column :newsletters, :valid, :boolean
  end
end
