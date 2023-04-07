class UpdateCursurisTable < ActiveRecord::Migration[7.0]
  def change
    remove_reference :cursuris, :user, foreign_key: true
    add_column :cursuris, :listacursuri_id, :integer
    add_column :cursuris, :user_id, :integer
    add_index :cursuris, :listacursuri_id
    add_index :cursuris, :user_id
    
  end
end
