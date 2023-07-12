
  # config/initializers/pdfkit.rb
PDFKit.configure do |config|
    if Rails.env.production?
      config.wkhtmltopdf = `which wkhtmltopdf`.chomp
    else
      # Configurarea pentru Windows
      config.wkhtmltopdf = 'C:\Program Files\wkhtmltopdf\bin\wkhtmltopdf.exe'
    end
  end
  
  