class CursuriHistory < ApplicationRecord
    self.table_name = "cursuri_history"
    belongs_to :user
    belongs_to :listacursuri
    validates :user_id, presence: true
    validates :listacursuri_id, presence: true
    validates :cursuri_id, presence: true
end
  