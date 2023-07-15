# app/mailers/devise/mailer.rb
class Devise::Mailer < Devise.parent_mailer.constantize
    include Devise::Mailers::Helpers
  
    def reset_password_instructions(record, token, opts={})
      headers["Custom-header"] = "Bar"
      opts[:subject] = "Instrucțiuni de resetare a parolei"  # aici ai modificat subiectul
      super
    end
  end
  