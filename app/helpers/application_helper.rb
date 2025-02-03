module ApplicationHelper
  SECRET_KEY = "secretkey1"
    def set_selected_values_to_session(selected_values)
      session[:selected_values] = selected_values.map do |value|
        { id: value[:id], value: value[:value] }
      end
    end
    def generate_session_token
      payload = { exp: 30.minutes.from_now.to_i }
      JWT.encode(payload, SECRET_KEY, 'HS256')
    end
    require 'nokogiri'
  require 'digest'

  def translate_text(text, target_lang = nil)
    return text unless text.present?
    
    target_lang ||= session[:locale] == "en" ? "EN" : "RO" if defined?(session)

    Rails.cache.fetch(["translation", text, target_lang], expires_in: 24.hours) do
      begin
        translated_text = DeeplService.new.translate(text, target_lang)
        unless translated_text == text  # ✅ Asigură-te că DeepL chiar a tradus textul
          Rails.logger.info "✅ Traducere realizată cu DeepL: #{text} -> #{translated_text}"
          return translated_text
        end
      rescue => e
        Rails.logger.error "❌ DeepL API failed: #{e.message}"
      end

      begin
        translated_text = GoogleTranslateService.new.translate(text, target_lang)
        unless translated_text == text  # ✅ Verifică dacă Google a tradus
          Rails.logger.info "✅ Traducere realizată cu Google Translate: #{text} -> #{translated_text}"
          return translated_text
        end
      rescue => e
        Rails.logger.error "❌ Google Translate API failed: #{e.message}"
      end

      begin
        translated_text = LibreTranslateService.new.translate(text, target_lang)
        unless translated_text == text  # ✅ Verifică dacă LibreTranslate a reușit
          Rails.logger.info "✅ Traducere realizată cu LibreTranslate: #{text} -> #{translated_text}"
          return translated_text
        end
      rescue => e
        Rails.logger.error "❌ LibreTranslate API failed: #{e.message}"
      end

      Rails.logger.error "❌ Toate serviciile de traducere au eșuat pentru textul: #{text}"
      text  # Doar dacă toate opțiunile au eșuat, returnează textul original
    end
  end
  
  def translate_html(html_content)
    return html_content unless html_content.present?

    doc = Nokogiri::HTML::DocumentFragment.parse(html_content)
    text_nodes = []

    doc.traverse do |node|
      if node.text? && node.content.strip.present?
        text_nodes << node
      end
    end

    return html_content if text_nodes.empty?

    text_to_translate = text_nodes.map(&:content).join("\n---\n")
    translated_texts = Rails.cache.fetch(["deepl_translation", text_to_translate, session[:locale]], expires_in: 24.hours) do
      Translation.find_or_update_translation(text_to_translate, session[:locale] == "en" ? "EN" : "RO")
    end

    translated_texts.split("\n---\n").each_with_index do |translated_text, index|
      text_nodes[index].content = translated_text if text_nodes[index]
    end

    doc.to_html.html_safe
  end
  end
  
