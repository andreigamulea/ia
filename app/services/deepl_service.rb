require 'faraday'
require 'json'

class DeeplService
  BASE_URL = "https://api-free.deepl.com/v2/translate"

  def initialize
    @api_key = Rails.application.credentials.dig(:deepl, :api_key)
  end

  def translate(text, target_lang = "EN", source_lang = "RO")
    return text unless text.present? && target_lang != source_lang  # Nu traduce dacă limba este aceeași

    response = Faraday.post(BASE_URL) do |req|
      req.headers['Authorization'] = "DeepL-Auth-Key #{@api_key}"
      req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
      req.body = URI.encode_www_form(
        text: text,
        target_lang: target_lang,
        source_lang: source_lang
      )
    end

    if response.success?
      JSON.parse(response.body)["translations"].first["text"]
    else
      Rails.logger.error "DeepL API error: #{response.body}"
      text  # Dacă API-ul eșuează, returnează textul original
    end
  end
end
