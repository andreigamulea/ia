class ChangeLastSignInIpTypeInUsers < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :last_sign_in_ip, :string
  end
end
