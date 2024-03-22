class WorkoutsController < ApplicationController
  
  def index
    @workouts = Workout.all
    
  end

  def show
    @workout = Workout.find(params[:id])
    @reservation_accepted = @workout.reservations.where(status: "accepted")
    @place_available = @workout.participant_number.to_i - @reservation_accepted.count.to_i
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

  def edit
    @workout = Workout.find(params[:id])
  end

  def update
    puts params.inspect
    @workout = Workout.find(params[:id])
    if @workout.update(workout_params)
        redirect_to @workout, notice: "Workout mis à jour avec succès."
    else
        flash[:error] = "Il y a une erreur lors de l'update de la réservation : #{@workout.errors.full_messages.to_sentence}"
        render :edit
    end
  end

  def destroy
    @workout = Workout.find(params[:id])
    @reservations = @workout.reservations
    puts @reservations.inspect
    if @workout.destroy
      @reservations.each do |reservation|
        reservation.status = "host_cancelled"
        reservation.save
      end
      redirect_to workouts_path, notice: "Workout supprimé avec succès."
    else
      flash[:error] = "Il y a une erreur lors de la suppression de la réservation : #{workout.errors.full_messages.to_sentence}"
      render :show
    end
  end
  
  private
  def workout_params
    params.require(:workout).permit(:title, :start_date, :end_date, :participant_number, :description, :price, :location, :city_id, :host_id)
  end
end
