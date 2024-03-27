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
    @session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      metadata: {
        user_id: @user_id
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
      success_url: checkout_success_url + '?session_id={CHECKOUT_SESSION_ID}',
      cancel_url: checkout_cancel_url
    )
    redirect_to @session.url, allow_other_host: true
  end

  def success
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)
    puts @payment_intent
    @user_id = @session.metadata.user_id
    @user = User.find(@user_id)
    @user.update(credit: @user.credit + @payment_intent.amount_received.to_f/100)
    UserMailer.payment_confirmation_email(@user, @payment_intent).deliver_now
  end

  def cancel
  end

end
