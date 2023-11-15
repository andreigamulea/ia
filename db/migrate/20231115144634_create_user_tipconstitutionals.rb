class CreateUserTipconstitutionals < ActiveRecord::Migration[7.0]
  def change
    create_table :user_tipconstitutionals do |t|
      t.references :user, null: false, foreign_key: true
      t.references :tipconstitutional, null: false, foreign_key: true
      t.integer :valoare

      t.timestamps
    end
  end
end
