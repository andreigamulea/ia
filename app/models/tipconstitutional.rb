class Tipconstitutional < ApplicationRecord
  has_many :user_tipconstitutionals
  has_many :users, through: :user_tipconstitutionals
end
