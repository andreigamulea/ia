class AddFieldsToContractes < ActiveRecord::Migration[7.0]
  def change
    add_column :contractes, :denumire_post, :string
    add_column :contractes, :locul_desfasurarii, :string
    add_column :contractes, :departament, :string
    add_column :contractes, :subordonare, :string
    add_column :contractes, :relatii_functionale, :string
  end
end
