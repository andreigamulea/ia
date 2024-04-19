class AddCodToFirma < ActiveRecord::Migration[7.0]
  def change
    add_column :firmas, :cod, :string
  end
end
