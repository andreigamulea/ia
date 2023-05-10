class CursuriHistory < ApplicationRecord
    self.table_name = "cursuri_history"
    belongs_to :user, optional: true
    belongs_to :listacursuri
    belongs_to :cursuri
    validates :user_id, presence: true
    validates :listacursuri_id, presence: true
  end
  