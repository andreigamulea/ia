class DateFacturare < ApplicationRecord
  before_save :normalize_cnp
  
  validates :user_id, :email, uniqueness: true
  
  # Validări de prezență pentru câmpurile comune
  validates :prenume, :nume, :tara, :codpostal, :strada, :numar, :telefon, :grupa2425, presence: true

  # Validare condiționată pentru județ și localitate
  validate :judet_and_localitate_validation
  validates :tara, presence: true,
  inclusion: { 
    in: ->(_) { Tari.pluck(:nume) },
    message: "nu este validă." 
  }

  private

  def judet_and_localitate_validation
    return if tara.blank?

    if tara.downcase == "romania"
      if judet.blank?
        errors.add(:judet, "este obligatoriu pentru România.")
      elsif !Judet.exists?(denjud: judet)
        errors.add(:judet, "nu există în baza de date.")
      end

      if localitate.blank?
        errors.add(:localitate, "este obligatorie pentru România.")
      elsif !Localitati.exists?(denumire: localitate, denj: judet)
        errors.add(:localitate, "nu aparține județului selectat.")
      end
    else
      if judet.blank?
        errors.add(:judet, "este obligatoriu (pentru țările din afara României).")
      end
      if localitate.blank?
        errors.add(:localitate, "este obligatorie (pentru țările din afara României).")
      end
    end
  end

  def normalize_cnp
    # Dacă CNP-ul nu are fix 13 cifre, îl setăm la 13 zerouri
    unless cnp.present? && cnp.match?(/\A\d{13}\z/)
      self.cnp = "0000000000000"
    end
  end
end
