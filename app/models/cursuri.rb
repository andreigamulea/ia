class Cursuri < ApplicationRecord
  belongs_to :user
  belongs_to :listacursuri
  #has_many :cursuri_histories, dependent: :nullify
end
