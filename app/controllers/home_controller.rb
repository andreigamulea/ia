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
##################################grupa 1
    
    if current_user && current_user.grupa == 1
      # Verificăm dacă există o înregistrare în ComenziProd unde user_id corespunde cu current_user și taxa2324 este 1
      comanda = ComenziProd.find_by(user_id: current_user.id, taxa2324: 1)
    
      # Dacă nu există astfel de înregistrare, setăm @prodgrupa1_taxainscriere
      @prodgrupa1_taxainscriere = comanda.nil? ? Prod.find_by(cod: "cod14") : nil
    else
      @prodgrupa1_taxainscriere = nil
    end
    if current_user && current_user.grupa == 1
          # Verificăm dacă există o înregistrare în ComenziProd unde user_id corespunde cu current_user și taxa2324 este 1
      exista_taxa2324_cu_1 = ComenziProd.exists?(user_id: current_user.id, taxa2324: 1)

      # Verificăm dacă există vreo înregistrare în ComenziProd unde user_id corespunde cu current_user și taxa2324 NU este 1
      exista_taxa2324_diferit_de_1 = ComenziProd.where(user_id: current_user.id).where.not(taxa2324: 1).exists?

      # Dacă există înregistrare cu taxa2324 setată ca 1 și nicio înregistrare cu valoare diferită de 1, setăm @prodgrupa1_taxaanuala
      if exista_taxa2324_cu_1 && !exista_taxa2324_diferit_de_1
        @prodgrupa1_taxaanuala = Prod.find_by(cod: "cod15")
      end

    end
    ###aici fac pentru lunile de la Octombrie la Iulie
    if current_user && current_user.grupa == 1
      valori_taxa2324 = ComenziProd.where(user_id: current_user.id).pluck(:taxa2324)
      
      # Verificăm dacă există valoarea 12
      if valori_taxa2324.include?(12)
        @prodgrupa1_taxalunara = nil
      elsif valori_taxa2324.empty? || !valori_taxa2324.include?(1)
        @prodgrupa1_taxalunara = nil
      else
        # Numărăm câte valori unice avem pentru a determina produsul corespunzător
        numar_valori = valori_taxa2324.uniq.count
        cod_produs = "cod#{15 + numar_valori}"  # Se adaugă 15 pentru că cod16 corespunde cu 1 valoare, cod17 cu 2 valori, etc.
        @prodgrupa1_taxalunara = Prod.find_by(cod: cod_produs)
      end
    end
    ####################final aici fac pentru lunile de la Octombrie la Iulie


##################################end grupa1
    
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
