class ChangeCurrentSignInIpTypeInUsers < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :current_sign_in_ip, :string
  end
end
