class AddResponsabilitatiVoluntarAndConditiiLucruToContractes < ActiveRecord::Migration[7.0]
  def change
    add_column :contractes, :responsabilitati_voluntar, :text
    add_column :contractes, :conditii_lucru, :text
  end
end
