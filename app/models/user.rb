class User < ApplicationRecord
  before_validation :downcase_email
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }

  has_many :cursuri
  has_many :listacursuri, through: :cursuri
  has_many :cursuri_history
  def admin?
    # Verifică dacă rolul este 1 (admin)
    role == 1
  end

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end       
  def full_message(attribute, message)
    if attribute == :password_confirmation && message == I18n.t('activerecord.errors.messages.confirmation')
      I18n.t('activerecord.errors.models.user.attributes.password_confirmation.custom_confirmation')
    else
      super
    end
  end
  
end