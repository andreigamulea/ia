class DetaliifacturaresController < ApplicationController
  before_action :authenticate_user!
  before_action :restrict_access_to_special_page, only: [:datefacturare]
  before_action :new, only: [:datefacturare] # remove :create
  skip_before_action :verify_authenticity_token, only: [:pay]

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
    @hide_header = true
    puts("sunt in createeeeeeeeeeeeeeeeeeeeee")
    @detaliifacturare = current_user.detaliifacturare || current_user.build_detaliifacturare

    @prod = Prod.find(detaliifacturare_params[:s])
    
    detaliifacturare_params_without_s = detaliifacturare_params.except(:s)
    @detaliifacturare.assign_attributes(detaliifacturare_params_without_s)    
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
    @hide_header = true
    puts("sunt in updateeeeeeeeeeeeeeeeeeeeee")
    @detaliifacturare = current_user.detaliifacturare
    @prod = Prod.find(detaliifacturare_params[:s])

    if @detaliifacturare.update(detaliifacturare_params.except(:s))
      puts("are client stripe")
      # Asigura-te că utilizatorul are un client Stripe
      if current_user.stripe_customer_id.nil?
        puts("im here in begin dupa if")
        begin
          customer = Stripe::Customer.create(email: current_user.email)
          current_user.update(stripe_customer_id: customer.id)
          puts("im here in begin")
          
        rescue => e
          Rails.logger.error "Stripe customer creation failed for user #{current_user.id}: #{e.message}"
          # Gestionare erori
          return
        end
      end  
      puts("im here inainte de format js")
      respond_to do |format|
        format.html { render :update } # Răspunde cu HTML
        format.js { render :update } # Răspunde cu js   
               
      end
      
    else
      puts("im here")
      render :datefacturare
    end
  end
  
  
  def pay
    puts("sunt in payeeeeeeeeeeeeeeeeeeeeee")
    @prod = Prod.find(params[:id])
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
      total: @prod.pret,
      plataprin: 'Stripe'
    )
    numar_comanda = Comanda.maximum(:id).to_i
    comanda.update(numar: numar_comanda)
    # Adaugă produsul la comandă
    ComenziProd.create!(
      comanda_id: comanda.id,
      prod_id: @prod.id,
      datainceput: Time.now,
      datasfarsit: Time.now + @prod.valabilitatezile.to_i.days
    )
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
  
  def detaliifacturare_params
    params.require(:detaliifacturare).permit(:prenume, :nume, :numecompanie, :cui, :tara, :judet, :localitate, :codpostal, :strada, :numar, :altedate, :telefon, :adresaemail,:s)
end

def restrict_access_to_special_page  #da acces doar la userii care sunt in tabela UserProd cu prod_id=9
  # Verifică dacă parametrul 's' este 9
  if params[:s] == '9'
    unless Userprod.exists?(user_id: current_user.id, prod_id: 9)
      flash[:alert] = "Nu aveți acces la această pagină."
      redirect_to root_path # sau orice altă cale unde doriți să redirecționați utilizatorul
    end
  end
end
end
