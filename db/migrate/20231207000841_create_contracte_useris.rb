class CreateContracteUseris < ActiveRecord::Migration[7.0]
  def change
    create_table :contracte_useris do |t|
      t.integer :user_id
      t.string :email
      t.integer :idcontractor
      t.integer :contracte_id
      t.text :contract_content
      t.text :signature_data

      t.timestamps
    end
  end
end
