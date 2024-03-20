class WorkoutsController < ApplicationController
  
  def index
    @workouts = Workout.all
  end

  def show
    @workout = Workout.find(params[:id])
    # @reservation = Reservation.new
  end

  def new
    @workout = Workout.new
    @cities = City.all
  end
  
  def create
    @workout = Workout.create(workout_params)
    if @workout.save
      redirect_to @workout, notice: 'La séance a été créé avec succès.'
    else
      puts @workout.errors.full_messages.to_sentence
      render :new
    end
  end
  private
  def workout_params
    params.require(:workout).permit(:title, :start_date, :end_date, :participant_number, :description, :price, :location, :city_id, :host_id)
  end
end
