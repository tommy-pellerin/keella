class WorkoutsController < ApplicationController
  
  def index
    @workouts = Workout.all
  end

  def show
    @workout = Workout.find(params[:id])
    @place_available = @workout.participant_number.to_i - @workout.reservations.count.to_i
  end

  def new
    @workout = Workout.new
  end
  
  def create
    @workout = Workout.create(workout_params)
    if @workout.save
      redirect_to @workout, notice: 'La séance a été créé avec succès.'
    else
      puts @workout.errors.full_messages.to_sentence
      flash[:error] = "Il y a une erreur lors de la création de la réservation : #{@workout.errors.full_messages.to_sentence}"
      render :new
    end
  end
  private
  def workout_params
    params.require(:workout).permit(:title, :start_date, :end_date, :participant_number, :description, :price, :location, :city_id, :host_id)
  end
end
