class AddDateFieldsToContracteUseris < ActiveRecord::Migration[7.0]
  def change
    add_column :contracte_useris, :data_cerere, :date
    add_column :contracte_useris, :data_gdpr, :date
    add_column :contracte_useris, :data_posta_ssm, :date
    add_column :contracte_useris, :data_bifa_ssm, :date
    add_column :contracte_useris, :data_posta_isu, :date
    add_column :contracte_useris, :data_bifa_isu, :date
    add_column :contracte_useris, :data_cv, :date
    add_column :contracte_useris, :data_fisha_postului, :date
  end
end
