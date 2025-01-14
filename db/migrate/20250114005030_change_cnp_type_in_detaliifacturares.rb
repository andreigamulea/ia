class ChangeCnpTypeInDetaliifacturares < ActiveRecord::Migration[7.1]
  def change
    change_column :detaliifacturares, :cnp, :string
  end
end
