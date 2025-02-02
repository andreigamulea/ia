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

  def translate_text(text)
    return text unless text.present?  # Evită erorile pe texte goale

    target_lang = session[:locale] == "en" ? "EN" : "RO"

    Rails.cache.fetch(["deepl_translation", text, target_lang], expires_in: 24.hours) do
      response = DeeplService.new.translate(text, target_lang)
      Rails.logger.info "🔄 Traducere salvată în cache: #{text} -> #{response}"
      response
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
      translated_text = DeeplService.new.translate(text_to_translate, session[:locale] == "en" ? "EN" : "RO")
      Rails.logger.info "🔄 Traducere bloc salvată în cache"
      translated_text
    end

    translated_texts.split("\n---\n").each_with_index do |translated_text, index|
      text_nodes[index].content = translated_text if text_nodes[index]
    end

    doc.to_html.html_safe
  end
  end
  
