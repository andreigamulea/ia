class AddContorStartToContractes < ActiveRecord::Migration[7.0]
  def change
    add_column :contractes, :contor_start, :integer
  end
end
