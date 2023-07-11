class User < ApplicationRecord
  before_validation :downcase_email
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  has_many :comandas
  has_many :facturas
  has_many :cursuri
  has_many :listacursuri, through: :cursuri
  has_many :cursuri_history
  has_many :userpaginisite
  has_many :paginisite, through: :userpaginisite
  #has_many :detaliifacturares, dependent: :destroy
  has_one :detaliifacturare, dependent: :destroy
  attribute :active, :boolean, default: true
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
  def to_s
    email
  end  
  after_create do
    begin
      customer = Stripe::Customer.create(email: email)
      update(stripe_customer_id: customer.id)
    rescue => e
      Rails.logger.error "Stripe customer creation failed for user #{id}: #{e.message}"
      # Aici poți adăuga cod adițional pentru a gestiona eroarea, dacă este necesar
    end
  end
  
end