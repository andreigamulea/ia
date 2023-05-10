class UpdateForeignKeyInCursuriHistory < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :cursuri_history, :users
    add_foreign_key :cursuri_history, :users, on_delete: :nullify
  end
end
