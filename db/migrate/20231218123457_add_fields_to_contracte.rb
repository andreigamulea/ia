class AddFieldsToContracte < ActiveRecord::Migration[7.0]
  def change
    add_column :contractes, :nume_firma, :string
    add_column :contractes, :sediu_firma, :string
    add_column :contractes, :cont_bancar, :string
    add_column :contractes, :banca_firma, :string
    add_column :contractes, :cui_firma, :string
    add_column :contractes, :reprezentant_firma, :string
  end
end
