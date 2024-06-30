class Contracte < ApplicationRecord #acest tabel este pentru contractori
    belongs_to :user
    has_many :contracte_acces_emails
    has_many :contracte_useris, dependent: :restrict_with_error
    validates :cod_contract, uniqueness: { scope: :cui_firma, message: "Nu puteți adăuga mai multe modele de contracte cu aceeași combinație de Serie Contract și CUI firmă." }


    validates :email, presence: true
    validates :tip, presence: true
    validates :denumire, presence: true
    validates :nume_firma, presence: true
    validates :sediu_firma, presence: true
    validates :cont_bancar, presence: true
    validates :banca_firma, presence: true
    validates :cui_firma, presence: true
    validates :reprezentant_firma, presence: true
    validates :calitate_reprezentant, presence: true
    validates :semnatura_admin, presence: true
    validates :cod_contract, presence: true
    validates :denumire_post, presence: true
    validates :locul_desfasurarii, presence: true
    validates :departament, presence: true
    validates :subordonare, presence: true
    validates :email_coordonator, presence: true
    validates :relatii_functionale, presence: true
    validates :contor_start, presence: true, numericality: { greater_than_or_equal_to: 1 }
    validates :valabilitate_luni, presence: true
    validates :sarcini_voluntar, presence: true
    validates :responsabilitati_voluntar, presence: true
    validates :conditii_lucru, presence: true
end
