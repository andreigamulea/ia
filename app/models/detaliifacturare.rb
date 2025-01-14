class Detaliifacturare < ApplicationRecord
  belongs_to :user
  validates :user_id, uniqueness: true
  validates :user_id, presence: true

  validates :prenume, :nume, :strada, :numar, :telefon, presence: { message: 'este obligatoriu' }

  validate :adresaemail_be_present
  validate :codpostal_be_present

  # Validare condiționată pentru județ și localitate
  validate :judet_and_localitate_validation

  validates :tara, presence: true, inclusion: { in: ->(_) { Tari.pluck(:nume) }, message: "nu este validă." }

  private

  def adresaemail_be_present
    errors.add(:adresaemail, 'Adresa de email este obligatorie') if adresaemail.blank?
  end

  def codpostal_be_present
    errors.add(:base, 'Cod postal') if codpostal.blank?
  end

  # Validare condiționată pentru județ și localitate
  def judet_and_localitate_validation
    if tara.present? && tara.downcase == "romania"
      # Pentru România, judet și localitate sunt obligatorii și trebuie să fie valide
      if judet.blank?
        errors.add(:judet, 'este obligatoriu pentru România.')
      elsif !Judet.exists?(denjud: judet)
        errors.add(:judet, 'nu este valid.')
      end

      if localitate.blank?
        errors.add(:localitate, 'este obligatorie pentru România.')
      elsif !Localitati.exists?(denumire: localitate, denj: judet)
        errors.add(:localitate, 'nu aparține județului selectat.')
      end
    else
      # Pentru alte țări, validăm doar ca valorile să fie prezente, nu și să fie în tabele
      if judet.blank?
        errors.add(:judet, 'este obligatoriu pentru țările din afara României.')
      end
      if localitate.blank?
        errors.add(:localitate, 'este obligatorie pentru țările din afara României.')
      end
    end
  end
end
