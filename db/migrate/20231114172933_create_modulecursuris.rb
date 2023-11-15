class CreateModulecursuris < ActiveRecord::Migration[7.0]
  def change
    create_table :modulecursuris do |t|
      t.string :nume

      t.timestamps
    end
  end
end
