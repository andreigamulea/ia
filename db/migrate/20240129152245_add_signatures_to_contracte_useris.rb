class AddSignaturesToContracteUseris < ActiveRecord::Migration[7.0]
  def change
    add_column :contracte_useris, :semnatura1, :text
    add_column :contracte_useris, :semnatura2, :text
    add_column :contracte_useris, :semnatura3, :text
    add_column :contracte_useris, :semnatura4, :text
  end
end
