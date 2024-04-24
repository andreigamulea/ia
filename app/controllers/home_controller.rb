class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:newsletter]
  before_action :set_user_admin, only: %i[panouadmin cazuriparticulare userip user77 listavegetalegratis]
  def index
    #render layout: false
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
  def documente
    @prod = Prod.find_by(curslegatura: 'documente', status: 'activ')
  end  
  def userip
    @userip= UserIp.all
  end  
  def user77
    users = User.all
    @aremail=[]
    
    users.each do |user|
      # Acțiuni pe care vrei să le faci pentru fiecare utilizator
      if user && user.valid_password?('')
        @aremail << user.email
      else
        # Parola nu este corectă
      end
    end    
  end  


  def newsletter #este o metoda de tip POST
    Rails.logger.debug "Params: #{params.inspect}"
  
    newsletter = Newsletter.new(newsletter_params)
    if newsletter.save
      render json: { message: "Înscriere reușită!" }, status: :created
    else
      render json: { errors: newsletter.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def lista_newsletter #afiseaza pe cei inscrisi
    if current_user && current_user.role==1
      @lista = Newsletter.all
      @n=0
      @nr_inscrisi=@lista.count
    else
      redirect_to root_path
    end  
  end  
 
  def rasayana
    @has_access = current_user&.role == 1
  
    # Verifică dacă userul curent există în UserModulecursuri cu condițiile specificate
    if current_user
      @has_access ||= UserModulecursuri.exists?(user_id: current_user.id, 
                                                modulecursuri_id: 3, 
                                                validat: "Finalizata")
    end
    @condition1 = if current_user
      if current_user.role == 1
        true
      else
        comanda = ComenziProd.where(user_id: current_user.id, validat: "Finalizata")
                            .where(prod_id: Prod.where(cod: ['cod72', 'cod74']).select(:id))
                            .order(datasfarsit: :desc)
                            .first
    
        if comanda && comanda.datasfarsit
          comanda.datasfarsit >= Date.today
        else
          false
        end
      end
    end
    
    
    
    if @has_access
      @myvideo4 = Video.where(tip: 'nutritie2').where('ordine > ? AND ordine < ?', 3000, 4000).order(ordine: :asc)
  
    end  
    if !current_user      
      @prods = Prod.where(curslegatura: 'nutritie2', status: 'activ', cod: 'cod72')
    elsif current_user && @has_access && @condition1
      @prods = Prod.none
      @platit=true # variabila care permite accesul la video
      @myvideo = Video.where(tip: 'nutritie2').where('ordine > ? AND ordine < ?', 0, 1000).order(ordine: :asc)  
    elsif @has_access
      
      @prods = Prod.where(curslegatura: 'nutritie2', status: 'activ', cod: 'cod74')
    else
      @prods = Prod.where(curslegatura: 'nutritie2', status: 'activ', cod: 'cod72')
    end
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
    @suma_achitata = @stripe_session.metadata[:pret_total]
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
      @user_has_bought_cod11_or_cod13 = @user_has_prod_cod11 || @user_has_prod_cod13
    else
      @user_has_prod_cod11 = false
      @user_has_prod_cod13 = false
      @user_has_bought_cod11_or_cod13 = false
    end
    
    
    
    #stoptvariabilele pt nutritie3

    
end

  
  
  
  
  
  def tabeleahoy
    if current_user.role==1
    @ahoy_visits = Ahoy::Visit.order(started_at: :desc).limit(30).includes(:user).reverse
    @ahoy_events = Ahoy::Event.order(time: :desc).limit(7000).includes(:user)
    @ahoy_events = @ahoy_events.map do |event|
      event.properties = event.properties[0..99] if event.properties.present?
      event
    end.reverse
    
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
  def export_newsletter_subscribers
    subscribers = Newsletter.all.order(:id)  # Assuming you want to export all records

    # Create a new workbook
    workbook = RubyXL::Workbook.new
    worksheet = workbook[0]
    worksheet.sheet_name = 'Subscribers'

    # Define headers for the spreadsheet
    headers = ['ID', 'Name', 'Email']
    headers.each_with_index do |header, index|
      worksheet.add_cell(0, index, header)
    end

    # Fill the spreadsheet with subscriber data
    subscribers.each_with_index do |subscriber, index|
      worksheet.add_cell(index + 1, 0, subscriber.id)
      worksheet.add_cell(index + 1, 1, subscriber.nume)
      worksheet.add_cell(index + 1, 2, subscriber.email)
    end

    # Save the workbook to a file
    file_path = Rails.root.join('tmp', 'newsletter_subscribers.xlsx')
    workbook.write(file_path)

    # Send the file to the user
    send_file(file_path, filename: 'newsletter_subscribers.xlsx', type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
  end
  private

  def valid_email?(email)
    # Utilizează o expresie regulată sau o altă metodă pentru a verifica validitatea adresei de email
    # Aici este un exemplu simplu utilizând expresii regulate
    email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    !!(email =~ email_regex)
  end
  def set_user_admin
    if !current_user
      redirect_to root_path, alert: "Nu ai permisiunea de a accesa această pagină."
      return
    end  
    unless current_user.role == 1
      redirect_to root_path, alert: "Nu ai permisiunea de a accesa această pagină."
      return
    end
  end
  def newsletter_params
    params.require(:newsletter).permit(:nume, :email, :validat)
  end
  
  
  
end
