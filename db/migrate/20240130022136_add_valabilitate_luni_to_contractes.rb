class AddValabilitateLuniToContractes < ActiveRecord::Migration[7.0]
  def change
    add_column :contractes, :valabilitate_luni, :integer
  end
end
