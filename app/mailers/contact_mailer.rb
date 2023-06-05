class ContactMailer < ApplicationMailer
  def contact_email(name, email, message)
    @name = name
    @message = message
    @email = email
  
    mail(to: 'ayushcellromania@gmail.com', from: 'contact-ayushcell@ayushcell.ro', subject: 'Mesaj Contact Ayushcell.ro')
  end
  
end

  