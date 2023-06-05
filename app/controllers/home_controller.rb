class HomeController < ApplicationController
  def index
  end
  def termeni_conditii
  end
  def politica_confidentialitate
  end    
  def politica_cookies
  end 
  def politica_gdpr
  end 
  def panouadmin
  end
  def tabeleahoy
    @ahoy_visits = Ahoy::Visit.order(started_at: :desc).limit(30).includes(:user).reverse
    @ahoy_events = Ahoy::Event.order(time: :desc).limit(2000).includes(:user).reverse


  end
  
  def contact
    if request.post?
      name = params[:name]
      email = params[:email]
      message = params[:message]

      if name.present? && email.present? && message.present?
        if valid_email?(email)
          ContactMailer.contact_email(name, email, message).deliver_now
          redirect_to contact_path, notice: "Mesajul a fost trimis cu succes!"
        else
          flash.now[:error] = "Adresa de email nu este validă!"
        end
      else
        flash.now[:error] = "Toate câmpurile trebuie completate!"
      end
    end
  end

  private

  def valid_email?(email)
    # Utilizează o expresie regulată sau o altă metodă pentru a verifica validitatea adresei de email
    # Aici este un exemplu simplu utilizând expresii regulate
    email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    !!(email =~ email_regex)
  end
end
