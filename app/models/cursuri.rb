class Cursuri < ApplicationRecord
  belongs_to :user
  belongs_to :listacursuri
  has_many :cursuri_history, dependent: :destroy
end
