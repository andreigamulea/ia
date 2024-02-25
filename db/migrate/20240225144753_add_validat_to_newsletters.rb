class AddValidatToNewsletters < ActiveRecord::Migration[7.0]
  def change
    add_column :newsletters, :validat, :boolean
  end
end
