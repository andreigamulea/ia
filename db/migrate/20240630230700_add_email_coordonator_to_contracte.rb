class AddEmailCoordonatorToContracte < ActiveRecord::Migration[7.0]
  def change
    add_column :contractes, :email_coordonator, :string
  end
end
