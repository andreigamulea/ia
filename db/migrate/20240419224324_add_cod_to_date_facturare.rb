class AddCodToDateFacturare < ActiveRecord::Migration[7.0]
  def change
    add_column :date_facturares, :cod, :string
  end
end
