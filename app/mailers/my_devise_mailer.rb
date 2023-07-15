class MyDeviseMailer < Devise::Mailer
    helper :application # adaugă helpers pe care dorești să le utilizezi în mailer views
    include Devise::Controllers::UrlHelpers # opțional. Adaugă link-uri de genul `confirmation_url`
    default template_path: 'devise/mailer' # pentru a face view-urile să funcționeze
  
    def reset_password_instructions(record, token, opts={})
      @token = token
      devise_mail(record, :reset_password_instructions, opts)
    end
  end
  