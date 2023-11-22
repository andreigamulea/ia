class CreateRedirectionLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :redirection_logs do |t|
      t.string :original_path
      t.string :redirected_to

      t.timestamps
    end
  end
end
