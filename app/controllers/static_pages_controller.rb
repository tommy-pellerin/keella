class StaticPagesController < ApplicationController
  def index
    @workouts = Workout.all.limit(3)
  end
  
end
