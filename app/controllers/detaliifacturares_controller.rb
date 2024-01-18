class DetaliifacturaresController < ApplicationController
  before_action :authenticate_user!
  before_action :restrict_access_to_special_page, only: [:datefacturare]
  before_action :new, only: [:datefacturare] # remove :create
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
    puts("sunt in createeeeeeeeeeeeeeeeeeeeee")
    @detaliifacturare = current_user.detaliifacturare || current_user.build_detaliifacturare
   
    @prod = Prod.find(detaliifacturare_params[:s])
    
    detaliifacturare_params_without_s = detaliifacturare_params.except(:s)
    @detaliifacturare.assign_attributes(detaliifacturare_params_without_s)    
    @detaliifacturare.use_alternate_shipping = params[:use_alternate_shipping] == "1"
    if @detaliifacturare.save
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
      render :datefacturare
    end
  
  end  
  














  def update
    puts("sunt in updateeeeeeeeeeeeeeeeeeeeee")
    @detaliifacturare = current_user.detaliifacturare

    @prod = Prod.find(detaliifacturare_params[:s])
    puts("Se setează valorile la nil")

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
        puts("erori")
        puts "Errors: #{@detaliifacturare.errors.full_messages}"
        render :datefacturare
    end
end

  
  
  def pay
   
    puts("sunt in payeeeeeeeeeeeeeeeeeeeeee")
    @prod = Prod.find(params[:id]) 
    if current_user.email=="nagy.edvin@yahoo.com" && @prod.cod.in?(['cod16', 'cod17', 'cod18', 'cod19', 'cod20', 'cod21', 'cod22', 'cod23', 'cod24', 'cod25'])
      @prod.pret=35 #situatie particulara
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
      datasfarsit: Time.now + @prod.valabilitatezile.to_i.days
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
      updated_at: @detaliifacturare.updated_at
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
            unit_amount: (@prod.pret * 100).to_i,
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

  
  
  def datefacturare
    @detaliifacturare = current_user.detaliifacturare || current_user.build_detaliifacturare
    @serviciu = params[:serviciu]
    @prod = Prod.find(params[:s].to_i)
  end
  
  

  private

  def new
    #@detaliifacturare = current_user.detaliifacturares.new
    @detaliifacturare = current_user.detaliifacturare || current_user.build_detaliifacturare

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
