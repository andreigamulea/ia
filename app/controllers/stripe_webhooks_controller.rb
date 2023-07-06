class StripeWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, Rails.application.credentials.stripe[:webhook_secret]
      )
    rescue JSON::ParserError => e
      # Invalid payload
      status 400
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      status 400
      return
    end

    # Handle the event
    case event.type
    when 'payment_intent.succeeded'
      payment_intent = event.data.object # contains a Stripe::PaymentIntent
      # Then define and call a method to handle a successful payment intent.
      handle_payment_intent_succeeded(payment_intent)
    when 'payment_intent.payment_failed'
      payment_intent = event.data.object # contains a Stripe::PaymentIntent
      # Then define and call a method to handle the failed payment intent.
      handle_payment_intent_payment_failed(payment_intent)
    end

    render json: { message: 'success' }
  end

  private

  def handle_payment_intent_succeeded(payment_intent)
    # Aici, presupunem că ai stocat `user_id` și `numar_comanda` în metadata 
    user_id = payment_intent.metadata['user_id']
    numar_comanda = payment_intent.metadata['numar_comanda']
  
    # Acum, găsești comanda în baza de date folosind numar_comanda și o actualizezi
    comanda = Comanda.find_by(numar: numar_comanda)
    
    if comanda
      comanda.update(statecomanda2: 'Finalizata')
    else
      Rails.logger.error "Nu s-a putut găsi comanda cu numarul #{numar_comanda} pentru actualizare"
    end
  end
  

  def handle_payment_intent_payment_failed(payment_intent)
    # Logic for handling failed payments.
  end
end


