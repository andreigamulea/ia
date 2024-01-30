class AddExpiraLaToContracteUseris < ActiveRecord::Migration[7.0]
  def change
    add_column :contracte_useris, :expira_la, :date
  end
end
