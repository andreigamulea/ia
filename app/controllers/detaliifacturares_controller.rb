class DetaliifacturaresController < ApplicationController
  before_action :authenticate_user!
  before_action :new, only: [:datefacturare] # remove :create
  skip_before_action :verify_authenticity_token, only: [:pay]
  def index
    @detaliifacturare = Detaliifacturare.all
  end
  def edit
    @detaliifacturare = Detaliifacturare.find(params[:id])
  end
  
  
  def show
    @detaliifacturare = User.find(params[:id]).detaliifacturare
  end
  def create     
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
  
  def update
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
    @prod = Prod.find(params[:id])
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
      #numar: numar_comanda,
      statecomanda1: 'Initiata',
      statecomanda2: 'Asteptare',
      stateplata1: 'Asteptare',
      stateplata2: 'Asteptare',
      stateplata3: 'Asteptare',
      user_id: current_user.id,
      emailcurrent: current_user.email,
      emailplata: 'Email_Plata',
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
          metadata: {
            user_id: current_user.id.to_s,
            email: current_user.email,
            numar_comanda: numar_comanda
          }
        },
        mode: 'payment',
        success_url: "#{servicii_url}?payment=success",
        cancel_url: root_url
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


end
