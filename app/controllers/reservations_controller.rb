class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :is_host?, only: [:edit]
  # before_action :status_is_pending?, only: [:edit]
  before_action :no_cache, only: [:edit]


  def create
    puts "#"*50
    puts "Je suis dans create de reservations_controller.rb"
    puts params
    puts "#"*50
    #create a reservation to pre-reserve a place, be careful, if the host doesn't refuse, the place is still reserved => need a conditoin to delete it after 48h ?
    @workout = Workout.find(params[:workout_id])
    @reservation = Reservation.create(workout: @workout, user: current_user)

    #change status to pending
    @reservation.status = "pending"
    @reservation.save
    puts "$"*50
    puts @reservation.status

    #send email to host => this job is done by the model itself with the callback after_create
    redirect_to workout_path(@workout)

    #reserve paiement => paiement status = pending

  end

  def edit
    @reservation = Reservation.find(params[:id])
    @user = @reservation.user
    if @reservation.status != "pending"
      redirect_to root_path, alert: "Vous avez déjà pris une décision pour cette réservation."
    end
  end

  def update
    puts "#"*50
    puts "je suis dans update de reservations_controller.rb"
    puts params
    puts "#"*50
    @reservation = Reservation.find(params[:id])
    decision = params[:decision]
    puts "$"*50
    puts @reservation.status

    if decision == "accepted"
      @reservation.status = "accepted"
      @reservation.save
      #paiement status = pending
      #send email to user to notify
    elsif decision == "refused"
      @reservation.status = "refused"
      @reservation.save
      #refund user
      #send email to user to notify    
    end
    puts "$"*50
    puts @reservation.status
    redirect_to edit_workout_reservation_path(@reservation.workout, @reservation)

    #if user cancel change status to canceled
      #send email to host to notify
    #refund user
      
    #if user confirm that the workout went well change status to closed
    #paie user => paiement status = paid
  end

  private

  def is_host?
    if current_user.id != Reservation.find(params[:id]).workout.host_id
      redirect_to root_path
    end
  end

  # def status_is_pending?
  #   puts "#"*50
  #   puts params
  #   puts  "#"*50
  #   @reservation = Reservation.find(params[:id])
  #   if @reservation.status != "pending"
  #     puts "$"*50
  #     puts "status is not pending"
  #     redirect_to root_path, notice: 'Vous avez déjà pris une décision pour cette réservation.'
  #   end
  # end 

  def no_cache
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  
end
