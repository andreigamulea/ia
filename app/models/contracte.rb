class Contracte < ApplicationRecord #acest tabel este pentru contractori
    belongs_to :user
    has_many :contracte_acces_emails
    has_many :contracte_useris
end
