class AddSemnaturaAdminToContracte < ActiveRecord::Migration[7.0]
  def change
    add_column :contractes, :semnatura_admin, :text
  end
end
