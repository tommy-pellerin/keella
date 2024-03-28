class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :is_host?, only: [:edit]
  before_action :status_is_pending?, only: [:edit]
  before_action :no_cache, only: [:edit]

  def index
    @reservations = current_user.reservations.order(created_at: :desc)
    
  end

  def show
    @user = User.find(params[:user_id])
    @workouts = Workout.where(host_id: @user.id).order(created_at: :desc)
  end
  
  def create
    puts "#"*50
    puts "Je suis dans create de reservations_controller.rb"
    puts params
    puts "#"*50
    #create a reservation to pre-reserve a place, be careful, if the host doesn't refuse, the place is still reserved => need a conditoin to delete it after 48h ?
    @workout = Workout.find(params[:workout_id])
    @reservation = Reservation.new(workout: @workout, user: current_user)
    #change status to pending
    @reservation.status = "pending"
    if @reservation.save      
      puts "$"*50
      puts @reservation.status
      #send email to host => this job is done by the model itself with the callback after_create
      #reserve paiement => paiement status = pending
      respond_to do |format|
        format.html { redirect_to @workout, notice: "Votre réservation a bien été prise en compte. Vous recevrez un email de confirmation. Pensez à vérifier vos spams." }      
      end
    else
      flash[:alert] = @reservation.errors.full_messages.join(", ")
      redirect_to @workout
    end 

  end

  def edit
    @reservation = Reservation.find(params[:id])
    @user = @reservation.user
  end

  def update
    puts "#"*50
    puts "je suis dans update de reservations_controller.rb"
    puts params
    puts "#"*50
    @reservation = Reservation.find(params[:id])
    host_decision = params[:host_decision]
    user_decision = params[:user_decision]
    
    puts "$"*50
    puts @reservation.status

    #host_decision zone
    if host_decision == "accepted"
      @reservation.status = "accepted"
      @reservation.save
      #paiement status = pending
      #send email to user to notify => this job is done by the model itself with the callback after_update
    elsif host_decision == "refused"
      @reservation.status = "refused"
      @reservation.save
      #refund user
      #send email to user to notify => this job is done by the model itself with the callback after_update
    # elsif host_decision == "host_cancelled"
    #   @reservation.status = "host_cancelled"
    #   @reservation.save
      #refund user
      #send email to user to notify => this job is done by the model itself with the callback after_update
    end

    #user_decision zone
    if user_decision == "user_cancelled"
      @reservation.status = "user_cancelled"
      @reservation.save
      #refund user
      #send email to host to notify => this job is done by the model itself with the callback after_update
    elsif user_decision == "closed"
      @reservation.status = "closed"
      @reservation.save
      #paie user => paiement status = paid
      #send email to host to notify => this job is done by the model itself with the callback after_update
      #send email to user to thank => this job is done by the model itself with the callback after_update

      #if user_decision == "relauched", the status is already "pending" so no need to change it
    end

    puts @reservation.status
    puts "$"*50
    @workouts = Workout.all
    respond_to do |format|
      format.html { redirect_to root_path }
      #format.turbo_stream { render turbo_stream: turbo_stream.replace("fullpage", partial: "reservation-tab", locals: {user: Reservation.host_id ,workouts: @workouts }) }
      format.turbo_stream { render turbo_stream: turbo_stream.replace("fullpage", partial: "reservation-tab") }
    end
    
  end

  private

  def is_host?
    if current_user.id != Reservation.find(params[:id]).workout.host_id
      redirect_to root_path
    end
  end

  def status_is_pending?
    puts "#"*50
    puts params
    puts  "#"*50
    @reservation = Reservation.find(params[:id])
    if @reservation.status != "pending"
      puts "$"*50
      puts "status is not pending"
      redirect_to root_path, notice: 'Vous avez déjà pris une décision pour cette réservation.'
    end
  end 

  def no_cache
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  
end
