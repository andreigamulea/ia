require 'digest'

class Translation < ApplicationRecord
  validates :original_text, presence: true
  validates :locale, presence: true
  validates :hash_value, presence: true, uniqueness: { scope: :locale }

  def self.find_or_update_translation(text, target_lang = "EN")
    new_hash = Digest::SHA256.hexdigest(text)
    translation = find_by(original_text: text, locale: target_lang)

    if translation.present?
      if translation.hash_value != new_hash
        Rails.logger.info "🔄 Textul s-a schimbat! Retraducem: #{text}"
        translated_text = DeeplService.new.translate(text, target_lang)
        translation.update(original_text: text, translated_text: translated_text, hash_value: new_hash, manual_text: nil)
      end
      return translation.manual_text.presence || translation.translated_text
    else
      Rails.logger.info "🔄 Traducere nouă cu DeepL: #{text}"
      translated_text = DeeplService.new.translate(text, target_lang)
      create(original_text: text, translated_text: translated_text, hash_value: new_hash, locale: target_lang)
      return translated_text
    end
  end
end
