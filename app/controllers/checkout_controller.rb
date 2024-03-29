class CheckoutController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @user = current_user
  end

  def create
    puts "#"*50
    puts "Je suis dans create de checkout_controller.rb"
    puts params
    puts "#"*50
    @total = params[:total].to_d
    @user_id = params[:user_id]
    @user = User.find(params[:user_id])

     # Generate a unique token
    @token = SecureRandom.uuid

    @session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      metadata: {
        user_id: @user_id,
        token: @token
      },
      line_items: [
        {
          price_data: {
            currency: 'eur',
            unit_amount: (@total*100).to_i,
            product_data: {
              name: 'Rails Stripe Checkout',
            },
          },
          quantity: 1
        },
      ],
      mode: 'payment',
      success_url: checkout_success_url + "?session_id={CHECKOUT_SESSION_ID}&token=#{@token}",
      cancel_url: checkout_cancel_url
    )
    @user.update(token: @token)
    redirect_to @session.url, allow_other_host: true
  end

  def success
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)
    # puts @payment_intent
    @user_id = @session.metadata.user_id
    @user = User.find(@user_id)

    # Check if the token in the URL matches the token stored with the user
    puts "Jaffiche le param token"
    # puts params[:token]
    if params[:token] == @user.token
      payment_proceed(@user, @payment_intent)
    else
      # If the tokens do not match, redirect the user
      redirect_to checkouts_path, notice: "Le paiement a déjà été traité."
    end

    # if @payment_intent.status == 'succeeded' && @user.payment_intent_id != @payment_intent.id
    #   payment_proceed(@user, @payment_intent)
    # end
  end

  def cancel
  end

  private

  def payment_proceed(user, payment_intent)
    @user = user
    @payment_intent = payment_intent
    @user.update(credit: @user.credit + @payment_intent.amount_received.to_f/100, token: nil)
    UserMailer.payment_confirmation_email(@user, @payment_intent).deliver_now
  end

end
