require "httparty"

class LibreTranslateService
  BASE_URL = "https://libretranslate.com/translate"  # Server public gratuit

  def translate(text, target_lang = "en", source_lang = "ro")
    return text unless text.present?

    response = HTTParty.post(BASE_URL, body: {
      q: text,
      source: source_lang,
      target: target_lang,
      format: "text"
    })

    if response.success?
      JSON.parse(response.body)["translatedText"]
    else
      Rails.logger.error "LibreTranslate API error: #{response.body}"
      text  # Dacă API-ul eșuează, returnează textul original
    end
  end
end
