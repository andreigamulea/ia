
class Detaliifacturare < ApplicationRecord
  belongs_to :user
  validates :user_id, uniqueness: true
  validates :user_id, presence: true
  
  validates :prenume, :nume, :tara, :localitate,  :strada, :numar, :telefon, presence: { message: '' }
  validate :adresaemail_be_present
  validate :codpostal_be_present
  validate :judet_be_present

  # Validări pentru adresa alternativă de livrare
  validates :prenume1, :nume1, :tara1, :localitate1, :strada1, :numar1, :telefon1, presence: { message: '' }, if: :use_alternate_shipping?
  
  validate :codpostal1_be_present, if: :use_alternate_shipping?
  validate :judet1_be_present, if: :use_alternate_shipping?

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

  # Metode pentru validarea adreselor alternative de livrare
  

  def codpostal1_be_present
    errors.add(:base, 'Cod postal (livrare)') if codpostal1.blank?
  end

  def judet1_be_present
    errors.add(:base, 'Judet / Sector (livrare)') if judet1.blank?
  end
  def use_alternate_shipping?
    self.use_alternate_shipping
  end
  
end
