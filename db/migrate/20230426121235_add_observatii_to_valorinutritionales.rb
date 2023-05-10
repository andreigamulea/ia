class AddObservatiiToValorinutritionales < ActiveRecord::Migration[7.0]
  def change
    add_column :valorinutritionales, :observatii, :text
  end
end
