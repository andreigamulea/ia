class HomeController < ApplicationController
  def index
  end
  def termeni_conditii
  end
  def politica_confidentialitate
  end    
  def politica_cookies
  end 
  def politica_gdpr
  end 
  def panouadmin
  end
 
  def resetareparola    
  end
  def cookiestest
  end
  def cazuriparticulare
  end  
  def userip
    @userip= UserIp.all
  end  

  def listavegetalegratis
    @acces = params[:acces]
    @mesaj1 = "Acces gratuit 24h"
    @mesaj2 = "Cautare selectiva in lista de ingrediente vegetale"
    if @acces == "da"
      redirect_to lista_vegetales_path
    elsif @acces == "nu" && current_user
      produs = "Lista vegetale"
  
      curs_exists = current_user.cursuri.any? { |curs| curs.listacursuri.nume == produs && (curs.datasfarsit.nil? || Date.current <= curs.datasfarsit) }
      Rails.logger.info "Curs exists?: #{curs_exists}"
      puts("intraaaaaaa")
      puts(current_user.id)
      unless curs_exists || UserIp.exists?(user_id: current_user.id, curspromo: produs) || UserIp.exists?(ip_address: current_user.last_sign_in_ip, curspromo: produs)
        curs_id = Listacursuri.find_by(nume: produs).id
        curs = Cursuri.find_or_initialize_by(listacursuri_id: curs_id, user_id: current_user.id)
        puts("daaaaaaaaaaa")
        curs.update!(
          datainceput: Time.now,
          datasfarsit: Time.now + 1.day,
          sursa: 'Promo 24h'
        )
        UserIp.create!(user_id: current_user.id, ip_address: current_user.last_sign_in_ip, curspromo: produs)
  
        # Adding entry to CursuriHistory
        CursuriHistory.create!(
          user_id: current_user.id,
          listacursuri_id: curs_id,
          cursuri_id: curs.id,
          datainceput: curs.datainceput,
          datasfarsit: curs.datasfarsit,
          email: current_user.email, # assuming the user model has an email attribute
          modificatde: 'Promo 24h'
        )
      else
        redirect_to servicii_path
      end
    end
  end
  
  
  
  
  def mergi
     @mesaj = params[:mesaj]
  end  
  def successtripe
    session_id = params[:session_id]
    @stripe_session = Stripe::Checkout::Session.retrieve(session_id)  
  
    # Data și ora tranzacției:
    @data_creare = Time.at(@stripe_session.created).to_datetime
    @data_creare_formatata = @data_creare.strftime('%d-%m-%Y %H:%M')
  
    # Suma achitată:
    id_produs = @stripe_session.metadata['id_produs'].to_i
    produs = Prod.find(id_produs)  # Presupunem că modelul 'Prod' are o coloană 'pret'
    @suma_achitata = produs.pret.round(0)
    @redirect_spre = produs.curslegatura
    if ('cod14'..'cod37').include?(produs.cod)
      @redirect_spre='cursayurveda'
    end  
    # Metoda de plată utilizată:
    @metoda_plata = @stripe_session.payment_method_types[0]  # Presupunem că există o singură metodă de plată
  
    # Numărul de referință al tranzacției:
    @numar_referinta = @stripe_session.metadata['numar_comanda']
  
    # Aici poti afisa sau redirecta catre view-ul tau
    # ...
  end
  
  

  
  def servicii
    special_prod_id = 9
    another_special_prod_id = 11

    if current_user && current_user.role == 1
      @prods = Prod.order(:id).to_a
    else
      @prods = Prod.where(status: 'activ').where.not(id: [special_prod_id, another_special_prod_id, 12]).order(:id).to_a

    end
  
    if params[:payment] == "success"
      flash[:notice] = "Plata a fost efectuată cu succes!"
    end
  
    # Verifică dacă utilizatorul curent există în Userprod cu prod_id special_prod_id și adaugă produsul la lista de afișat
    if current_user
      if Userprod.exists?(user_id: current_user.id, prod_id: another_special_prod_id)
        # Dacă utilizatorul are acces la produsul cu ID-ul 11
        if !@prods.find { |prod| prod.id == another_special_prod_id }
          another_special_prod = Prod.find(another_special_prod_id)
          @prods << another_special_prod
        end
        
        # Dă-le și acces la produsul cu ID-ul 12
        if !@prods.find { |prod| prod.id == 12 }
          prod_12 = Prod.find(12)
          @prods << prod_12
        end
      end
    
      # Logica pentru produsul special cu ID-ul 9 (ca mai înainte)
      if Userprod.exists?(user_id: current_user.id, prod_id: special_prod_id) && !@prods.find { |prod| prod.id == special_prod_id }
        special_prod = Prod.find(special_prod_id)
        @prods << special_prod
      end
    end
    #@prod_tayt12 = Prod.where(curslegatura: 'tayt12')
    #@prod_tayt12 = Prod.where(curslegatura: 'tayt12').order(:cod)
    @prod_tayt12 = Prod.where(curslegatura: 'tayt12', status: 'activ').order(:cod)


    #startvariabilele pt nutritie3
    @prod_id_cod11 = Prod.find_by(cod: 'cod11')&.id
    @prod_id_cod13 = Prod.find_by(cod: 'cod13')&.id
    
   

    if current_user
      @user_has_prod_cod11 = ComenziProd.exists?(user_id: current_user.id, prod_id: @prod_id_cod11, validat: 'Finalizata')
      @user_has_prod_cod13 = ComenziProd.exists?(user_id: current_user.id, prod_id: @prod_id_cod13, validat: 'Finalizata')
    else
      @user_has_prod_cod11 = false
      @user_has_prod_cod13 = false
    end
    
    
    #stoptvariabilele pt nutritie3

    
end

  
  
  
  
  
  def tabeleahoy
    if current_user.role==1
    @ahoy_visits = Ahoy::Visit.order(started_at: :desc).limit(30).includes(:user).reverse
    @ahoy_events = Ahoy::Event.order(time: :desc).limit(200).includes(:user).reverse
    end

  end
  
  def contact
    
    if request.post?
      name = params[:name]
      email = params[:email]
      message = params[:message]

      if name.present? && email.present? && message.present?
        if valid_email?(email)
          ContactMailer.contact_email(name, email, message).deliver_now
          redirect_to contact_path, notice: "Mesajul a fost trimis cu succes!"
        else
          flash.now[:error] = "Adresa de email nu este validă!"
        end
      else
        flash.now[:error] = "Toate câmpurile trebuie completate!"
      end
    end
  
  end

  private

  def valid_email?(email)
    # Utilizează o expresie regulată sau o altă metodă pentru a verifica validitatea adresei de email
    # Aici este un exemplu simplu utilizând expresii regulate
    email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    !!(email =~ email_regex)
  end
end
