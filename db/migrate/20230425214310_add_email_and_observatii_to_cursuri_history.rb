class AddEmailAndObservatiiToCursuriHistory < ActiveRecord::Migration[7.0]
  def change
    add_column :cursuri_history, :email, :string
    add_column :cursuri_history, :observatii, :text
  end
end


