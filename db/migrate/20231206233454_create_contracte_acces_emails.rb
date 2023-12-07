class CreateContracteAccesEmails < ActiveRecord::Migration[7.0]
  def change
    create_table :contracte_acces_emails do |t|
      t.integer :contracte_id
      t.string :email
      t.integer :idcontractor

      t.timestamps
    end
  end
end
