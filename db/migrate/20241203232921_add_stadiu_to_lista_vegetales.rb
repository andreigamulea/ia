class AddStadiuToListaVegetales < ActiveRecord::Migration[7.1]
  def change
    add_column :lista_vegetales, :stadiu, :string
  end
end
