class AddAddressFieldsToContracteUseri < ActiveRecord::Migration[7.0]
  def change
    add_column :contracte_useris, :localitate_voluntar, :string
    add_column :contracte_useris, :strada_voluntar, :string
    add_column :contracte_useris, :numarstrada_voluntar, :string
    add_column :contracte_useris, :bloc_voluntar, :string
    add_column :contracte_useris, :judet_voluntar, :string
  end
end
