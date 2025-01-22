class AddCnpAndAbrJudToFacturas < ActiveRecord::Migration[7.1]
  def change
    add_column :facturas, :cnp, :string
    add_column :facturas, :abr_jud, :string
  end
end
