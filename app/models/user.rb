class User < ApplicationRecord
  before_validation :downcase_email
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }

  has_many :cursuri
  has_many :listacursuri, through: :cursuri
  def admin?
    # Verifică dacă rolul este 1 (admin)
    role == 1
  end

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end       

  
end