class AddSarciniVoluntarToContractes < ActiveRecord::Migration[7.0]
  def change
    add_column :contractes, :sarcini_voluntar, :text
  end
end
