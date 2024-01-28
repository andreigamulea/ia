class AddCodContractToContractes < ActiveRecord::Migration[7.0]
  def change
    add_column :contractes, :cod_contract, :string
  end
end
