class WorkoutsController < ApplicationController
  def index
    
  end

  def show
    @workout = Workout.find(params[:id])
    # @reservation = Reservation.new
  end

  
end
