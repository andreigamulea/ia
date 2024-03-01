class RenameDataFishaPostuluiToDataFisaPostuluiInContracteUseris < ActiveRecord::Migration[7.0]
  def change
    rename_column :contracte_useris, :data_fisha_postului, :data_fisa_postului
  end
end
