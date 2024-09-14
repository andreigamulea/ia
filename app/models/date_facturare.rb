class DateFacturare < ApplicationRecord
    validates :user_id, :email, uniqueness: true    
    validates :prenume, :nume, :tara, :codpostal, :strada, :numar, :telefon, :localitate, :judet, :grupa2425, presence: true
  end
  
