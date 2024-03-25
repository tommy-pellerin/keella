class StaticPagesController < ApplicationController
  def index
    @workouts = Workout.all
  end

  def aide
  end
  
end
