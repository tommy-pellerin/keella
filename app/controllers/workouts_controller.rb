class WorkoutsController < ApplicationController
  
  def index
    @workouts = Workout.all
  end

  def show
    @workout = Workout.find(params[:id])
    @place_available = @workout.participant_number.to_i - @workout.reservations.count.to_i
  end

  
end
