class AddTelefonVoluntarToContracteUseris < ActiveRecord::Migration[7.0]
  def change
    add_column :contracte_useris, :telefon_voluntar, :string
  end
end
