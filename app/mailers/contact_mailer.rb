class ContactMailer < ApplicationMailer
  def contact_email(name, email, message)
    @name = name
    @email = email
    @message = message

    mail(to: 'ayushcellromania@gmail.com', subject: 'Mesaj de la ayushcell.ro')
  end
end

  