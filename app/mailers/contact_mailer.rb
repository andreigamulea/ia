class ContactMailer < ApplicationMailer
  def contact_email(name, email, message)
    @name = name
    @message = message
    @email = email
  
    mail(to: 'ayushcellromania@gmail.com', from: 'noreply@ayushcell.ro', subject: 'Mesaj de la ayushcell.ro')
  end
  
end

  