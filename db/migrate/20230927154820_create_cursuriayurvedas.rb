class CreateCursuriayurvedas < ActiveRecord::Migration[7.0]
  def change
    create_table :cursuriayurvedas do |t|
      t.string :grupa

      t.timestamps
    end
  end
end
