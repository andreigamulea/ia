class Devise::PasswordsController < ::Devise::PasswordsController
  include TurboDeviseControllerConcern
  
  def create
    Rails.logger.info("Inside passwords#create")
    super do |resource|
      if resource.errors.empty?
        session[:password_reset] = true
        Rails.logger.info("Set password reset session to: #{session[:password_reset]}")
        flash.discard # Discard the flash message before redirection
      end
    end
  end

  def update
    Rails.logger.info("Inside passwords#update")
    super do |resource|
      if resource.errors.empty?
        session[:password_reset] = true
        Rails.logger.info("Set password reset session to: #{session[:password_reset]}")
      else
        Rails.logger.info("Resource errors: #{resource.errors.full_messages}")
      end
    end
  end
end






