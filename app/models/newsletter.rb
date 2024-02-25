# app/models/newsletter.rb
class Newsletter < ApplicationRecord
  validates :email, uniqueness: true
end
  