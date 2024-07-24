class AddTaxa2425ToComenziProd < ActiveRecord::Migration[7.0]
  def change
    add_column :comenzi_prods, :taxa2425, :integer
  end
end
