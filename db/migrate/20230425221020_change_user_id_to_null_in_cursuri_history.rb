class ChangeUserIdToNullInCursuriHistory < ActiveRecord::Migration[7.0]
  def change
    change_column_null :cursuri_history, :user_id, true
  end
end
