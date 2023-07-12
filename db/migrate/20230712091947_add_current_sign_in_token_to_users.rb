class AddCurrentSignInTokenToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :current_sign_in_token, :string
  end
end
