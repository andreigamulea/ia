class Accescurs2425 < ApplicationRecord
    self.table_name = 'accescurs2425'  #u.accescurs2425 asa se apeleaza
    belongs_to :user, inverse_of: :accescurs2425
  end
  