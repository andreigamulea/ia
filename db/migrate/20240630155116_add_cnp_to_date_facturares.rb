class AddCnpToDateFacturares < ActiveRecord::Migration[7.0]
  def change
    add_column :date_facturares, :cnp, :string
  end
end
