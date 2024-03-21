class StaticPagesController < ApplicationController
  def index
    @workouts = Workout.all
  end
end
