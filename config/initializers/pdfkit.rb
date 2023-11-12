

PDFKit.configure do |config|
    if Rails.env.production?
      config.wkhtmltopdf = `which wkhtmltopdf`.chomp
    else
      # Configurarea pentru Windows
      config.wkhtmltopdf = 'C:\Program Files\wkhtmltopdf\bin\wkhtmltopdf.exe'
    end
  end
  
  ###  de verificat daca las ce e mai jos daca merg facturile
  #PDFKit.configure do |config|
    #unless Rails.env.production?
      #config.wkhtmltopdf = 'C:\Program Files\wkhtmltopdf\bin\wkhtmltopdf.exe'
    #end
  #end
  