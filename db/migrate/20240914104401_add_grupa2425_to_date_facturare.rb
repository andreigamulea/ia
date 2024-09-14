class AddGrupa2425ToDateFacturare < ActiveRecord::Migration[7.1]
  def change
    add_column :date_facturares, :grupa2425, :string
  end
end
