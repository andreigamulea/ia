class CreateValorinutritionales < ActiveRecord::Migration[7.0]
  def change
    create_table :valorinutritionales do |t|
      t.integer :cod
      t.string :aliment
      t.float :calorii
      t.float :proteine
      t.float :lipide
      t.float :carbohidrati
      t.float :fibre

      t.timestamps
    end
    add_index :valorinutritionales, :cod
    add_index :valorinutritionales, :aliment
    add_index :valorinutritionales, :calorii
    add_index :valorinutritionales, :proteine
    add_index :valorinutritionales, :lipide
    add_index :valorinutritionales, :carbohidrati
    add_index :valorinutritionales, :fibre
  end
end
