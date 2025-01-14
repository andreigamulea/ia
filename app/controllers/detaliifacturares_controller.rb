class DetaliifacturaresController < ApplicationController
  require 'bigdecimal'
  require 'bigdecimal/util' # For to_d method
  before_action :authenticate_user!
  before_action :restrict_access_to_special_page, only: [:datefacturare]
  before_action :new, only: [:datefacturare, :datefacturarep] ## remove :create
  skip_before_action :verify_authenticity_token, only: [:pay]
  before_action :require_admin, only: %i[index edit edit1 show]

  def index
    @detaliifacturare = Detaliifacturare.all.order(id: :desc)
    
  end
  def edit
    
    @detaliifacturare = Detaliifacturare.find(params[:id])
  end
  
  
  def show
    @detaliifacturare = User.find(params[:id]).detaliifacturare
  end
  def edit1
    
    @detaliifacturare = Detaliifacturare.find(params[:id])
  end
  
  def update1
    @detaliifacturare = Detaliifacturare.find(params[:id])
    
    if @detaliifacturare.update(detaliifacturare_params)
      redirect_to detaliifacturares_path
    else
      render 'edit1'
    end
  end
  def create   
    puts("sunt in create")
    @detaliifacturare = current_user.detaliifacturare || current_user.build_detaliifacturare   
    if session[:din_datefacturarep]==false
      @prod = Prod.find(detaliifacturare_params[:s])   
      
      puts("Se setează valorile la nil")

      #pret_total = params[:pret_total].to_f
      if params[:pret_total].present? && params[:pret_total].to_f > 0
        session[:pret_total] = params[:pret_total]
        session[:cantitate] = params[:cantitate]
        session[:pret_bucata] = params[:pret_bucata]
        session[:multiplu] = true
        session[:obs] =  params[:obs]
      else
        session[:pret_total] = @prod.pret
        session[:cantitate] = 1
        session[:pret_bucata] = @prod.pret
        session[:multiplu] = false
        session[:obs] = 'curent'
      end
      @cantitate = session[:cantitate].to_i
      @pret_bucata = session[:pret_bucata].to_d
      @pret_total = session[:pret_total].to_d
      #@multiplu = session[:multiplu] == 'true'
      puts("pret_total din create11111=#{@pret_total}")
else
        @prod=Prod.find(session[:s])  
    
    
        @cantitate = session[:cantitate].to_i
        @pret_bucata = session[:pret_bucata].to_d
        @pret_total = session[:pret_total].to_d
        @obs = session[:obs]
        if @cantitate>1
          @multiplu = session[:multiplu] == 'true'
        else
          @multiplu = session[:multiplu] == 'false'
        end
        puts("Produs ID: #{@prod.id}")
        puts("pret_total din creaeeeeeeee2222222=#{@pret_total}")

end  


puts("pret_total din updateeeeeeee=#{@pret_total}")

    
    detaliifacturare_params_without_s = detaliifacturare_params.except(:s)
    @detaliifacturare.assign_attributes(detaliifacturare_params_without_s)    
    @detaliifacturare.use_alternate_shipping = params[:use_alternate_shipping] == "1"
    puts("inainte de salvare")
    if @detaliifacturare.save
      puts("dupa salvare")
       # Asigura-te că utilizatorul are un client Stripe
      if current_user.stripe_customer_id.nil?
        begin
          customer = Stripe::Customer.create(email: current_user.email)
          current_user.update(stripe_customer_id: customer.id)
          redirect_to pay_path
        rescue => e
          Rails.logger.error "Stripe customer creation failed for user #{current_user.id}: #{e.message}"
          # Gestionare erori
          return
        end
      end  
     
    else
      set_values_for_render #este o metoda pe care o gasesti in private
      puts("##############")
      puts @detaliifacturare.errors.full_messages
      puts("##############")
      render :datefacturare
    end
  
  end  
  










 




  def update
    
    puts("sunt in updateeeeeeeeeeeeeeeeeeeeee")
    @detaliifacturare = current_user.detaliifacturare
    if session[:din_datefacturarep]==false
            @prod = Prod.find(detaliifacturare_params[:s])   
            
            puts("Se setează valorile la nil")

            #pret_total = params[:pret_total].to_f
            if params[:pret_total].present? && params[:pret_total].to_f > 0
              session[:pret_total] = params[:pret_total]
              session[:cantitate] = params[:cantitate]
              session[:pret_bucata] = params[:pret_bucata]
              session[:multiplu] = true
              session[:obs] =  params[:obs]
            else
              session[:pret_total] = @prod.pret
              session[:cantitate] = 1
              session[:pret_bucata] = @prod.pret
              session[:multiplu] = false
              session[:obs] = 'curent'
            end
            @cantitate = session[:cantitate].to_i
            @pret_bucata = session[:pret_bucata].to_d
            @pret_total = session[:pret_total].to_d
            #@multiplu = session[:multiplu] == 'true'
            puts("pret_total din updateeeeeeee11111=#{@pret_total}")
    else
              @prod=Prod.find(session[:s])  
          
          
              @cantitate = session[:cantitate].to_i
              @pret_bucata = session[:pret_bucata].to_d
              @pret_total = session[:pret_total].to_d
              @obs = session[:obs]
              if @cantitate>1
                @multiplu = session[:multiplu] == 'true'
              else
                @multiplu = session[:multiplu] == 'false'
              end
              puts("Produs ID: #{@prod.id}")
              puts("pret_total din updateeeeeeee2222222=#{@pret_total}")

    end  
    

    puts("pret_total din updateeeeeeee=#{@pret_total}")

    update_attributes = detaliifacturare_params
    puts "Valoare altedate: #{@detaliifacturare.altedate}"
    puts "Valoare altedate1: #{@detaliifacturare.altedate1}"
    unless params[:use_alternate_shipping] == "1"
        puts("daaaa  este 0")
        update_attributes.merge!({
            prenume1: nil,
            nume1: nil,
            numecompanie1: nil,
            tara1: nil,
            localitate1: nil,
            judet1: nil,
            codpostal1: nil,
            strada1: nil,
            numar1: nil,
            altedate1: nil,
            telefon1: nil
        })
    end

    if @detaliifacturare.update(detaliifacturare_params.except(:s))

        # Asigura-te că utilizatorul are un client Stripe
        if current_user.stripe_customer_id.nil?
            begin
                customer = Stripe::Customer.create(email: current_user.email)
                current_user.update(stripe_customer_id: customer.id)
            rescue => e
                Rails.logger.error "Stripe customer creation failed for user #{current_user.id}: #{e.message}"
                # Gestionare erori
                return
            end
        end

        respond_to do |format|
            format.html { render :update } # Răspunde cu HTML
            format.js { render :update } # Răspunde cu JS
        end
        puts("nu sunt erori")
    else
        set_values_for_render #este o metoda pe care o gasesti in private
        puts("erori")
        puts "Errors: #{@detaliifacturare.errors.full_messages}"
        render :datefacturare
    end
end

  
  
  def pay
    
    @cantitate = session[:cantitate].to_i
    @pret_bucata = session[:pret_bucata].to_d
    @pret_total = session[:pret_total].to_d
    @obs = session[:obs]
    @multiplu = session[:multiplu] == 'true'

    puts("pret tot: #{@pret_total}")
    puts("cantite: #{@cantitate}")
    puts("pret bucata: #{@pret_bucata}")
    puts("Multiplu: #{@multiplu}")
    puts("Obs: #{@obs}")
    puts("sunt in payeeeeeeeeeeeeeeeeeeeeee")
    @prod = Prod.find(params[:id]) 
    emailuri_90 = ["ce.hermkens@gmail.com","mileamihaela1975@gmail.com"]
    if current_user.email == "nagy.edvin@yahoo.com" && @prod.cod.in?(['cod16', 'cod17', 'cod18', 'cod19', 'cod20', 'cod21', 'cod22', 'cod23', 'cod24', 
      'cod25', 'cod207', 'cod197', 'cod198', 'cod199', 'cod200', 'cod201', 'cod202', 'cod203', 'cod204', 'cod205', 'cod206'])
    @prod.pret = 35 # situatie particulara pentru nagy.edvin
    @pret_total = 35
    @pret_bucata = 35
  elsif emailuri_90.include?(current_user.email) && @prod.cod.in?(['cod207', 'cod197', 'cod198', 'cod199', 'cod200', 'cod201', 'cod202', 'cod203', 'cod204', 'cod205', 'cod206'])
    @prod.pret = 90 # situatie particulara pentru emailurile din array
    @pret_total = 90
    @pret_bucata = 90
  end
    @detaliifacturare = current_user.detaliifacturare
    # Asigura-te că utilizatorul are un client Stripe
    if current_user.stripe_customer_id.nil?
      begin
        customer = Stripe::Customer.create(email: current_user.email)
        current_user.update(stripe_customer_id: customer.id)
      rescue => e
        Rails.logger.error "Stripe customer creation failed for user #{current_user.id}: #{e.message}"
        # Gestionare erori
        return
      end
    end
    # Adaugă comanda în baza de date   

    comanda = Comanda.create!(
      datacomenzii: Time.now,
      statecomanda1: 'Initiata',
      statecomanda2: 'Asteptare',
      stateplata1: 'Asteptare',
      stateplata2: 'Asteptare',
      stateplata3: 'Asteptare',
      user_id: current_user.id,
      emailcurrent: current_user.email,
      emailplata: @detaliifacturare.adresaemail,
      telefon: @detaliifacturare.telefon,
      total: @prod.pret,
      plataprin: 'Stripe',
      prodid: @prod.id,
      prodcod: @prod.cod
    )
    numar_comanda = Comanda.maximum(:id).to_i #asta asigura ca id este la fel cu numar_comanda
    comanda.update(numar: numar_comanda)
    # Adaugă produsul la comandă
    ComenziProd.create!(
      comanda_id: comanda.id,
      prod_id: @prod.id,
      user_id: current_user.id,
      validat: "Initiata",
      datainceput: Time.now,
      datasfarsit: Time.now + @prod.valabilitatezile.to_i.days,
      cantitate: @cantitate,
      pret_bucata: @pret_bucata,
      pret_total: @pret_total,
      obs: @obs
    )

####################start populeaza adresacomenzi
# Presupunem că ai o comandă nou creată, @comanda

# Inițializează un hash pentru atributele noii înregistrări
atribute_adresacomenzi = { comanda_id: comanda.id }

if @detaliifacturare.use_alternate_shipping
  atribute_adresacomenzi.merge!(
    adresacoincide: false,
    prenume:       @detaliifacturare.prenume1,
    nume:          @detaliifacturare.nume1,
    numecompanie:  @detaliifacturare.numecompanie1.presence,
    cui:           @detaliifacturare.cui.presence,
    tara:          @detaliifacturare.tara1,
    judet:         @detaliifacturare.judet1,
    localitate:    @detaliifacturare.localitate1,
    codpostal:     @detaliifacturare.codpostal1,
    strada:        @detaliifacturare.strada1,
    numar:         @detaliifacturare.numar1,
    altedate:      @detaliifacturare.altedate1.presence,
    telefon:       @detaliifacturare.telefon1,
    email:         @detaliifacturare.adresaemail
  )
else
  atribute_adresacomenzi.merge!(
    adresacoincide: true,
    prenume:       @detaliifacturare.prenume,
    nume:          @detaliifacturare.nume,
    numecompanie:  @detaliifacturare.numecompanie.presence,
    cui:           @detaliifacturare.cui.presence,
    tara:          @detaliifacturare.tara,
    judet:         @detaliifacturare.judet,
    localitate:    @detaliifacturare.localitate,
    codpostal:     @detaliifacturare.codpostal,
    strada:        @detaliifacturare.strada,
    numar:         @detaliifacturare.numar,
    altedate:      @detaliifacturare.altedate.presence,
    telefon:       @detaliifacturare.telefon,
    email:         @detaliifacturare.adresaemail
  )
end

# Crearea unei noi înregistrări în tabela adresacomenzi cu atributele specificate
AdresaComenzi.create!(atribute_adresacomenzi)




###################stop populeaza adresacomenzi

    puts "@prod.valabilitatezile: #{@prod.valabilitatezile}"

    # Creare metadata
    metadata = {
      user_id: current_user.id.to_s,
      email: current_user.email,
      numar_comanda: numar_comanda,
      id_produs: @prod.id,
      nume: @detaliifacturare.nume,
      prenume: @detaliifacturare.prenume,
      numecompanie: @detaliifacturare.numecompanie,
      cui: @detaliifacturare.cui,            
      tara: @detaliifacturare.tara,
      strada: @detaliifacturare.strada,
      numar: @detaliifacturare.numar,
      altedate: @detaliifacturare.altedate,
      adresaemail: @detaliifacturare.adresaemail,            
      judet: @detaliifacturare.judet,
      localitate: @detaliifacturare.localitate,
      codpostal: @detaliifacturare.codpostal,
      telefon: @detaliifacturare.telefon,
      updated_at: @detaliifacturare.updated_at,
      cantitate: @cantitate,
      pret_bucata: @pret_bucata,
      pret_total: @pret_total
    }
  
    # Creează PaymentIntent
    begin
      @session = Stripe::Checkout::Session.create({
        payment_method_types: ['card'],
        line_items: [{
          price_data: {
            currency: 'ron',
            product_data: {
              name: @prod.nume
            },
            #unit_amount: (@prod.pret * 100).to_i,
            unit_amount: (@pret_total.to_d.round(2) * 100).to_i,
            #unit_amount: 1200,
            
          },
          quantity: 1,          
        }],
        payment_intent_data: {
          metadata: metadata
        },
        mode: 'payment',
        success_url: "#{successtripe_url}?session_id={CHECKOUT_SESSION_ID}",

        cancel_url: root_url,
        metadata: metadata
      })
      render json: {message: "sunt in create s-a creat", session_id: @session.id}
    rescue => e
      Rails.logger.error "Failed to create checkout session: #{e.message}"
      render json: {error: e.message}, status: :internal_server_error
      return
    end
end
def get_judets
  tara = params[:tara] # Obține țara din parametrii URL
  if tara == "Romania"
    # Returnează toate județele din baza de date
    judets = Judet.all.pluck(:denjud)
    render json: judets, status: :ok
  else
    # Pentru alte țări, returnează o listă goală
    render json: [], status: :ok
  end
end
def get_localitatis
  judet = params[:judet] # Obține județul selectat din parametrii URL
  if judet.present?
    # Selectează localitățile din județul specificat și le sortează alfabetic după `denumire`
    localitati = Localitati.where(denj: judet).order(:denumire)
    render json: localitati, status: :ok
  else
    render json: [], status: :ok
  end
end
def tara
  query = params[:q].to_s.downcase
  results = Tari.where("LOWER(nume) LIKE ?", "%#{query}%").pluck(:nume)
  render json: results
end

def judet
  query = params[:q].to_s.downcase
  results = Judet.where("LOWER(denjud) LIKE ?", "%#{query}%").pluck(:denjud)
  render json: results
end

def localitate
  query = params[:q].to_s.downcase
  results = Localitati.where("LOWER(denumire) LIKE ?", "%#{query}%").pluck(:denumire)
  render json: results
end
def autocomplete_tara
    query = params[:q].to_s.downcase.strip
    if query.present?
      results = Tari.where("LOWER(nume) LIKE ?", "%#{query}%").pluck(:nume)
      render json: results, status: :ok
    else
      render json: [], status: :ok
    end
  end

  def autocomplete_judet
    query = params[:q].to_s.downcase.strip
    if query.present?
      results = Judet.where("LOWER(denjud) LIKE ?", "%#{query}%").pluck(:denjud)
      render json: results, status: :ok
    else
      render json: [], status: :ok
    end
  end

  def autocomplete_localitate
    query = params[:q].to_s.downcase.strip
    filter = params[:filter].to_s.downcase.strip # Județul selectat
    if query.present? && filter.present?
      results = Localitati.where("LOWER(denumire) LIKE ? AND LOWER(denj) = ?", "%#{query}%", filter).pluck(:denumire)
      render json: results, status: :ok
    else
      render json: [], status: :ok
    end
  end
  
def datefacturare
  
  @detaliifacturare = current_user.detaliifacturare || current_user.build_detaliifacturare
  @tari=Tari.all
  @jud=Judet.all
  @loc=Localitati.all
  @serviciu = params[:serviciu]

  # Preia ID-ul produsului din params în loc de session
  @prod = Prod.find(params[:s].to_i) if params[:s].present?

  # Folosește valorile din params pentru a seta variabilele, cu o conversie adecvată
  @cantitate = (params[:cantitate] || 1).to_i  
  @pret_bucata = (params[:pret_bucata] || (@prod&.pret || 0)).to_d
  @pret_total = (params[:pret_total] || (@prod&.pret || 0) * @cantitate).to_d
  @obs=params[:obs]
  puts("pret total din datefacturare: #{@pret_total}")
  puts("cantitate: #{@cantitate}")
  puts("pret bucata: #{@pret_bucata}")
  puts("obs: #{@obs}")
  session[:s] = @prod.id if @prod.present?
  session[:cantitate] = @cantitate
  session[:pret_bucata] = @pret_bucata
  session[:pret_total] = @pret_total
  session[:obs] = @obs
  if params[:s] == '114'
    puts("s este 114 cantitate: #{session[:cantitate]}")
    @pret_bucata, @pret_total = calculate_price_for_contractes(session[:cantitate])
    session[:pret_bucata] = @pret_bucata
    session[:pret_total] = @pret_total



  else
    puts("s nu este 114: #{params[:s]}")  
  end  
  session[:multiplu] = (@cantitate > 1).to_s ## De exemplu, presupunând că multiplu înseamnă mai mult de o unitate
  session[:din_datefacturarep] = false 
  puts("pret total din datefacturarepost: #{@pret_total}")
  puts("cantitate: #{@cantitate}")
  puts("pret bucata: #{@pret_bucata}")
  puts("obs: #{@obs}")
  render 'datefacturare'
end

def datefacturarep
  
  @detaliifacturare = current_user.detaliifacturare || current_user.build_detaliifacturare
  @serviciu = params[:serviciu]

  # Preia ID-ul produsului din params în loc de session
  @prod = Prod.find(params[:s].to_i) if params[:s].present?

  # Folosește valorile din params pentru a seta variabilele, cu o conversie adecvată
  @cantitate = (params[:cantitate] || 1).to_i  
  @pret_bucata = (params[:pret_bucata] || (@prod&.pret || 0)).to_d
  @pret_total = (params[:pret_total] || (@prod&.pret || 0) * @cantitate).to_d
  @obs=params[:obs]

  # Salvarea valorilor în sesiune
  session[:s] = @prod.id if @prod.present?
  session[:cantitate] = @cantitate
  session[:pret_bucata] = @pret_bucata
  session[:pret_total] = @pret_total
  session[:obs] = @obs

  if params[:s] == '114'
    puts("s este 114 cantitate: #{session[:cantitate]}")
    @pret_bucata, @pret_total = calculate_price_for_contractes(session[:cantitate])
    session[:pret_bucata] = @pret_bucata
    session[:pret_total] = @pret_total



  else
    puts("s nu este 114: #{params[:s]}")  
  end  


  session[:multiplu] = (@cantitate > 1).to_s # De exemplu, presupunând că multiplu înseamnă mai mult de o unitate
  session[:din_datefacturarep] = true 
  puts("pret total din datefacturarepost: #{@pret_total}")
  puts("cantitate: #{@cantitate}")
  puts("pret bucata: #{@pret_bucata}")
  puts("obs: #{@obs}")
  render 'datefacturare'
end


  
  

  private
  def set_values_for_render
    @prod = Prod.find(params[:s] || session[:s].to_i)
    @cantitate = session[:cantitate].to_i
    @pret_bucata = session[:pret_bucata].to_d
    @pret_total = session[:pret_total].to_d
    @multiplu = session[:multiplu] == 'true'
    # Orice alte variabile necesare pentru view
    puts("pret total din set: #{@pret_total}")
    puts("cantitate: #{@cantitate}")
    puts("pret bucata: #{@pret_bucata}")
    puts("obs: #{@obs}")

  end

  def new
    #@detaliifacturare = current_user.detaliifacturares.new
    @detaliifacturare = current_user.detaliifacturare || current_user.build_detaliifacturare

  end
  
  def calculate_price_for_contractes(quantity)
    price_per_unit = case quantity
                     when 1..10
                       -0.0667 * quantity + 5.8667
                     when 11..20
                       -0.04 * quantity + 5.6
                     when 21..100
                       -0.0125 * quantity + 5.05
                     else
                       3.8
                     end
  
    total_price = price_per_unit * quantity
    return price_per_unit, total_price  # Returns both values
  end
  
def restrict_access_to_special_page
  # Dacă utilizatorul este admin, nu aplica restricții
  return if current_user && current_user.role == 1
  
  # Aici, 's' este parametrul URL care indică produsul
  target_prod_id = params[:s].to_i

  # Verifică dacă ID-ul produsului din parametru este 9, 11 sau 12
  if [9].include?(target_prod_id)
    if target_prod_id == 9
      unless Userprod.exists?(user_id: current_user.id, prod_id: 9)
        deny_access
      end
    else
     
    end
  end
end

def deny_access
  flash[:alert] = "Nu aveți acces la această pagină."
  redirect_to root_path # sau orice altă cale unde doriți să redirecționați utilizatorul
end

def detaliifacturare_params
  params.require(:detaliifacturare).permit(
    :prenume, :nume, :numecompanie, :cui, :tara, :judet, :localitate, 
    :codpostal, :strada, :numar, :altedate, :telefon, :adresaemail, :s,
    :prenume1, :nume1, :numecompanie1, :tara1, :codpostal1, :strada1, 
    :numar1, :localitate1, :judet1, :altedate1, :telefon1, 
    :use_alternate_shipping # presupunând că ai adăugat acest câmp pentru a ține evidența căsuței bifate
  )
end
end
