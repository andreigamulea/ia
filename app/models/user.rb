class User < ApplicationRecord
  before_validation :downcase_email
  before_validation :set_default_role
  before_validation :set_default_taxa
 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable,
         :omniauthable, omniauth_providers: [:google_oauth2]
         

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  
  has_many :facturaproformas, foreign_key: :user_id
  #def self.from_omniauth(auth)
   # user = find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
    #  user.email = auth.info.email
     # user.password = Devise.friendly_token[0, 20]
     # puts "Token primit de la Google: #{auth.credentials.token}"
     #user.name = auth.info.name   # assuming the user model has a name
   # end
    
   # user.google_token = auth.credentials.token # save the google token
   # user.save!
   # user
 # end
 def self.ransackable_attributes(auth_object = nil)
  ["active", "cnp", "cpa", "created_at", "current_sign_in_at", "current_sign_in_ip", "email", "gdpr", "google_refresh_token", "google_token", "grupa", "grupa2425", "id", "id_value", "last_sign_in_at", "last_sign_in_ip", "limba", "name", "nutritieabsolvit", "provider", "remember_created_at", "reset_password_sent_at", "reset_password_token", "role", "sign_in_count", "stripe_customer_id", "telefon", "telefon2", "telefon3", "uid", "updated_at"]
end

# Metoda ransackable_associations pentru a permite căutarea prin asociații
def self.ransackable_associations(auth_object = nil)
  ["accescurs2324s", "accescurs2425", "comandas", "comenzi_prods", "contractes", "cursuri", "cursuri_history", "detaliifacturare", "facturaproformas", "facturas", "listacursuri", "modulecursuris", "paginisite", "prods", "tipconstitutionals", "user_ips", "user_modulecursuris", "user_tipconstitutionals", "user_videos", "userpaginisite", "userprods", "videos"]
end
  def self.from_omniauth(auth)
    # Verifica daca exista un utilizator cu aceeasi adresa de email
    existing_user = find_by(email: auth.info.email)
  
    # Daca exista, actualizam utilizatorul existent
    if existing_user
      existing_user.assign_attributes(provider: auth.provider, uid: auth.uid, google_token: auth.credentials.token)
      existing_user.save!
      return existing_user
    else
      # Daca nu exista, cream sau gasim utilizatorul folosind provider si uid
      user = find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.name = auth.info.name
      end
      
      user.google_token = auth.credentials.token
      user.save!
      return user
    end
  end
  
 
  has_many :contractes
  has_many :user_modulecursuris
  has_many :modulecursuris, through: :user_modulecursuris
  
  has_many :user_tipconstitutionals
  has_many :tipconstitutionals, through: :user_tipconstitutionals

  has_many :user_videos
  has_many :videos, through: :user_videos
  
  has_many :accescurs2324s
  
  has_many :accescurs2425, class_name: 'Accescurs2425', foreign_key: 'user_id', inverse_of: :user
  
 
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


  def self.update_taxa_for_users
    User.find_each do |user|
      # Găsim valorile maxime pentru taxa2324 și taxa2425
      max_taxa2324 = user.comenzi_prods.maximum(:taxa2324)
      max_taxa2425 = user.comenzi_prods.maximum(:taxa2425)
  
      # Inițializăm un nou hash pentru taxa
      new_taxa = {}
  
      # Verificăm valorile din 'gr' pentru a decide cum să formăm hash-ul 'taxa'
      if user.gr.present?
        if user.gr['an2324'].is_a?(Array) && user.gr['an2324'].include?(1) && (user.gr['an2425'].nil? || user.gr['an2425'].empty?)
          # Dacă în 'gr' este doar 'an2324' => [1], setăm doar an2324 în taxa
          new_taxa['an2324'] = { 'an1' => max_taxa2324 } if max_taxa2324.present?
        elsif user.gr['an2324'].is_a?(Array) && user.gr['an2324'].include?(1) && user.gr['an2425'].is_a?(Array) && user.gr['an2425'].include?(2)
          # Dacă în 'gr' avem 'an2324' => [1] și 'an2425' => [2], setăm ambele
          new_taxa['an2324'] = { 'an1' => max_taxa2324 } if max_taxa2324.present?
          new_taxa['an2425'] = { 'an2' => max_taxa2425 } if max_taxa2425.present?
        elsif user.gr['an2425'].is_a?(Array) && user.gr['an2425'].include?(1) && (user.gr['an2324'].nil? || user.gr['an2324'].empty?)
          # Dacă în 'gr' este doar 'an2425' => [1], setăm doar an2425 în taxa
          new_taxa['an2425'] = { 'an1' => max_taxa2425 } if max_taxa2425.present?
        end
      end
  
      # Salvăm hash-ul 'taxa' doar dacă a fost populat
      user.update(taxa: new_taxa) if new_taxa.present?
    end
  end
  


  def self.update_gr_for_users
    User.find_each do |user|
      # Găsim valorile maxime pentru taxa2324 și taxa2425
      max_taxa2324 = user.comenzi_prods.maximum(:taxa2324)
      max_taxa2425 = user.comenzi_prods.maximum(:taxa2425)
  
      # Inițializăm hash-ul 'gr' gol
      new_gr = {}
  
      # Stabilim valoarea pentru an2324
      if max_taxa2324.present? && max_taxa2324 > 10
        # Dacă taxa2324 > 10, setăm an2324 la [1]
        new_gr['an2324'] = [1]
      elsif max_taxa2324.present? && max_taxa2324 > 0
        # Dacă taxa2324 este între 1 și 10, setăm an2324 la [1]
        new_gr['an2324'] = [1]
      end
  
      # Stabilim valoarea pentru an2425
      if max_taxa2425.present? && max_taxa2425 > 0
        # Dacă taxa2425 > 0, setăm an2425 la [1] sau [2], în funcție de condiții
        new_gr['an2425'] = if max_taxa2324.present? && max_taxa2324 > 10
                             [2] # Setăm an2425 la [2] dacă taxa2324 > 10
                           else
                             [1] # Altfel, setăm an2425 la [1]
                           end
      end
  
      # Salvăm hash-ul în tabela 'gr' dacă este populat
      user.update(gr: new_gr) if new_gr.present?
    end
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
  def set_default_taxa
    self.taxa ||= {}
  end
  
end