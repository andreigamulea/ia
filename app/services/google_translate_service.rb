require "google/cloud/translate"

class GoogleTranslateService
  def initialize
    @translator = Google::Cloud::Translate.translation_v2_service
  end

  def translate(text, target_lang = "en")
    return text unless text.present?

    response = @translator.translate text, to: target_lang
    response.text
  rescue => e
    Rails.logger.error "Google Translate API error: #{e.message}"
    text  # Dacă API-ul eșuează, returnează textul original
  end
end
