class UsersController < ApplicationController
  before_action :authenticate_user!
  

  def index

  end
  
  def show
    @user = User.find(params[:id])
    @workouts = Workout.where(host_id: @user.id)
    @reservation = Reservation.find(66)
    #@reservations = @user.reservations
  end

end
