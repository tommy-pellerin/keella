class WorkoutsController < ApplicationController
  def index
  end

  def show
    @workout = Workout.find(params[:id])
  end

  def new
  end
end
