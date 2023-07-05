class Detaliifacturare < ApplicationRecord
  belongs_to :user
  validates :user_id, uniqueness: true
  validates :user_id, presence: true
  
  validates :prenume, :nume, :tara, :localitate,  :strada, :numar, :telefon, presence: { message: '' }
  validate :adresaemail_be_present
  validate :codpostal_be_present
  validate :judet_be_present
  private

  def adresaemail_be_present
    errors.add(:base, 'Adresa de email') if adresaemail.blank?
  end
  def codpostal_be_present
    errors.add(:base, 'Cod postal') if codpostal.blank?
  end
  def judet_be_present
    errors.add(:base, 'Judet / Sector') if judet.blank?
  end
end
