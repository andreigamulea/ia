PDFKit.configure do |config|
  if Rails.env.production? && !Gem.win_platform?
    # Doar pentru sisteme non-Windows în producție
    config.wkhtmltopdf = `which wkhtmltopdf`.chomp
  else
    # Configurarea pentru Windows sau pentru dezvoltare non-producție
    config.wkhtmltopdf = 'C:/Program Files/wkhtmltopdf/bin/wkhtmltopdf.exe'
  end
end
  
  
  