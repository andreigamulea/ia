class AddNumarAndDataaToListaVegetales < ActiveRecord::Migration[7.0]
  def change
    add_column :lista_vegetales, :numar, :integer
    add_column :lista_vegetales, :dataa, :date
    add_index :lista_vegetales, :dataa
  end
end
