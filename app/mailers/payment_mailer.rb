class PaymentMailer < ApplicationMailer
    def payment_success_email(factura)
      @factura = factura
      if @factura.cui.present? || @factura.nume_companie.present? 
        mail(to: "ayushcellromania@gmail.com", subject: 'Factura noua pe ayushcell.ro', from: 'Factura-pe-firma@ayushcell.ro')
      else
        mail(to: "ayushcellromania@gmail.com", subject: 'Factura noua pe ayushcell.ro', from: 'Factura-pers-fizica@ayushcell.ro')
      end  
    end

    

    def billing_details_email(user, factura)
      @user = user
      @factura = factura
      
      #mail(to: "ilates@yahoo.com", subject: 'Confirmare plata comanda noua pe ayushcell.ro', from: 'comenzi@ayushcell.ro')

      mail(to: "ilates@yahoo.com", 
          subject: 'Confirmare plata comanda noua pe ayushcell.ro', 
          reply_to: 'ayushcellromania@gmail.com', 
          from: 'comenzi@ayushcell.ro')
    end
  end
  
  