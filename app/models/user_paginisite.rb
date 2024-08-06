class UserPaginisite < ApplicationRecord
  belongs_to :user
  belongs_to :paginisite
  def self.ransackable_attributes(auth_object = nil)
    %w[created_at id paginisite_id updated_at user_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user paginisite]
  end
end
