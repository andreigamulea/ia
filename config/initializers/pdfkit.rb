# config/initializers/pdfkit.rb
PDFKit.configure do |config|
    config.wkhtmltopdf = `which wkhtmltopdf`.chomp
  end
  