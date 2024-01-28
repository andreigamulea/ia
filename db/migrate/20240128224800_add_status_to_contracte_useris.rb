class AddStatusToContracteUseris < ActiveRecord::Migration[7.0]
  def change
    add_column :contracte_useris, :status, :string
  end
end
