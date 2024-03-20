class WorkoutsController < ApplicationController
  
  def index
    @workouts = Workout.all
  end

  def show
    @workout = Workout.find(params[:id])
    # @reservation = Reservation.new
  end

  
end
