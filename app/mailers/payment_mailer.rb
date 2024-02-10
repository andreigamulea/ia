class PaymentMailer < ApplicationMailer
    def payment_success_email(factura)
      @factura = factura
      mail(to: "ayushcellromania@gmail.com", subject: 'Factura noua pe ayushcell.ro', from: 'Facturi_ayushcell.ro@ayushcell.ro')
    end
  end
  
  