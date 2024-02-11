class PaymentMailer < ApplicationMailer
    def payment_success_email(factura)
      @factura = factura
      if @factura.cui.present? || @factura.nume_companie.present? 
        mail(to: "ayushcellromania@gmail.com", subject: 'Factura noua pe ayushcell.ro', from: 'Factura-pe-firma@ayushcell.ro')
      else
        mail(to: "ayushcellromania@gmail.com", subject: 'Factura noua pe ayushcell.ro', from: 'Factura-pers-fizica@ayushcell.ro')
      end  
    end
  end
  
  