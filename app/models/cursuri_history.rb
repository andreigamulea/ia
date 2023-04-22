class CursuriHistory < ApplicationRecord
    self.table_name = "cursuri_history"
    belongs_to :user
    belongs_to :listacursuri
    #belongs_to :cursuri, optional: true, class_name: "Cursuri", foreign_key: "cursuri_id"
    validates :user_id, presence: true
    validates :listacursuri_id, presence: true
  end
  