class AddCnpAndAbrJudToAdresacomenzi < ActiveRecord::Migration[7.1]
  def change
    add_column :adresacomenzi, :cnp, :string
    add_column :adresacomenzi, :abr_jud, :string
  end
end
