class ReservationsController < ApplicationController
  before_action :authenticate_user!
  
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

    #send email to host => this job is done by the model itself with the callback after_create
    redirect_to root_path    

    #reserve paiement => paiement status = pending

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
    redirect_to root_path 

    #if user cancel change status to canceled
      #send email to host to notify
    #refund user
      
    #if user confirm that the workout went well change status to closed
    #paie user => paiement status = paid
  end
  
end
