class AddDetailsToContracteUseris < ActiveRecord::Migration[7.0]
  def change
    add_column :contracte_useris, :nume_voluntar, :string
    add_column :contracte_useris, :domiciliu_voluntar, :string
    add_column :contracte_useris, :ci_voluntar, :string
    add_column :contracte_useris, :eliberat_de, :string
    add_column :contracte_useris, :eliberat_data, :date
    add_column :contracte_useris, :perioada_contract, :integer
    add_column :contracte_useris, :coordonator_v, :string
    add_column :contracte_useris, :data_inceperii, :date
    add_column :contracte_useris, :semnatura_voluntar, :text
    add_column :contracte_useris, :semnatura_administrator, :text
  end
end

