class CreateTranslations < ActiveRecord::Migration[7.1]
  def change
    create_table :translations do |t|
      t.text :original_text
      t.text :translated_text
      t.text :manual_text
      t.string :locale
      t.string :hash_value

      t.timestamps
    end
  end
end
