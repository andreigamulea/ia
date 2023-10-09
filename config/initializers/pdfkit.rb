
PDFKit.configure do |config|
  if Rails.env.production?
    config.wkhtmltopdf = Gem.bin_path('wkhtmltopdf-binary', 'wkhtmltopdf')
  else
    # Configurarea pentru Windows
    config.wkhtmltopdf = 'C:\Program Files\wkhtmltopdf\bin\wkhtmltopdf.exe'
  end
end

#