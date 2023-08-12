class Userprod < ApplicationRecord
    belongs_to :user
    belongs_to :prod
  end