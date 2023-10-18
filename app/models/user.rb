class User < ApplicationRecord
  before_validation :downcase_email
  before_validation :set_default_role
 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable,
         :omniauthable, omniauth_providers: [:google_oauth2]
         

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  

  def self.from_omniauth(auth)
    user = find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      puts "Token primit de la Google: #{auth.credentials.token}"
      user.name = auth.info.name   # assuming the user model has a name
    end
    
    user.google_token = auth.credentials.token # save the google token
    user.save!
    user
  end
  
  
 
  
 


  has_many :user_videos
  has_many :videos, through: :user_videos
  
  has_many :accescurs2324s
 
  has_many :userprods
  has_many :prods, through: :userprods
  has_many :comandas
  has_many :comenzi_prods#asta e noua
  has_many :facturas
  has_many :cursuri
  has_many :listacursuri, through: :cursuri
  has_many :cursuri_history
  has_many :userpaginisite
  has_many :paginisite, through: :userpaginisite
  has_many :user_ips
  #has_many :detaliifacturares, dependent: :destroy
  has_one :detaliifacturare, dependent: :destroy
  attribute :active, :boolean, default: true
  def admin?
    # Verifică dacă rolul este 1 (admin)
    role == 1
  end
  def active?
    active.nil? || active
  end
 def signed_in_on_this_device?(session_token)
    self.current_sign_in_token == session_token
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
  
  def set_default_role
    self.role ||= 0
  end
 
  
end