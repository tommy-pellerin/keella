class WorkoutsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :is_host?, only: [:edit]
  before_action :one_reservation, only: [:edit, :update]
  
  def index
    puts "#"*50
    puts "je suis dans index de workouts_controller.rb"
    puts params
    puts "#"*50
    
    if params[:showed_workout_number]
      
      showed_workout_number = params[:showed_workout_number].to_i
    else 
      showed_workout_number = 3 #number of workout to show at the beginning
    end

    if params[:city_id].present?
      @workouts = Workout.where(city_id: params[:city_id]).limit(showed_workout_number)
    else
      @workouts = Workout.all.limit(showed_workout_number)
    end
    
    @next_workouts = showed_workout_number + 3 #number of workout to show at the beginning and to show more after clicking on "voir plus"
    puts showed_workout_number
    puts @next_workouts
    @all_showed = all_showed(showed_workout_number)
  
  end

  def show
    @workout = Workout.find(params[:id])
    @reservation = Reservation.new
    @reservation_accepted = @workout.reservations.where(status: "accepted")
    @total = @workout.price + 1

  end

  def new
    @workout = Workout.new
  end

  def create
    @workout = Workout.create(workout_params)
    if @workout.save
      redirect_to edit_workout_path(@workout), notice: "Pour Finalisé la création de votre évènement, veuillez ajouter les images ici"
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


  def is_host?
    @workout = Workout.find(params[:id])
    if current_user.id != @workout.host_id
      flash[:error] = "Vous n'êtes pas l'hôte de cet événement."
      redirect_to root_path
    end
  end

  def all_showed(showed_workout_number)

    if params[:city_id].present?
      @all_workouts = Workout.where(city_id: params[:city_id])
    else
      @all_workouts = Workout.all
    end
    return showed_workout_number >= @all_workouts.count
  end

  def one_reservation
    @workout = Workout.find(params[:id])
    if @workout.reservations.where.not(status: ['refused','user_cancelled']).count > 0
      flash[:warning] = "Vous ne pouvez pas modifier un évènement qui a déjà au moins une réservation."
      redirect_to request.referrer
    end
  end

end
