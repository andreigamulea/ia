class AddModificatdeToCursuriHistory < ActiveRecord::Migration[7.0]
  def change
    add_column :cursuri_history, :modificatde, :string

  end
end
