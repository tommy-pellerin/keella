class ReservationsController < ApplicationController
  
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

  def update
    #if host refuse change status to refused
    
    # case 
    # when "accepted"
    #   @reservation.status = "pending"
    #   @reservation.save
    # end
      #send email to user to notify
    #if user cancel change status to canceled
      #send email to host to notify
    #refund user

    #if host accept change status to accepted
      #send email to user to notify
      #paiement status = pending

    #if user confirm that the workout went well change status to closed
    #paie user => paiement status = paid
  end
  
end
