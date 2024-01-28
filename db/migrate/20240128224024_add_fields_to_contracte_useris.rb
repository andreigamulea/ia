class AddFieldsToContracteUseris < ActiveRecord::Migration[7.0]
  def change
    add_column :contracte_useris, :prenume, :string
    add_column :contracte_useris, :cod_contract, :string
    add_column :contracte_useris, :nr_contract_referinta, :integer
  end
end
