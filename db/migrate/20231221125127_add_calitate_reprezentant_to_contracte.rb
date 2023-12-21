class AddCalitateReprezentantToContracte < ActiveRecord::Migration[7.0]
  def change
    add_column :contractes, :calitate_reprezentant, :string
  end
end
