class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :is_host?, only: [:edit]
  before_action :status_is_pending?, only: [:edit]
  before_action :no_cache, only: [:edit]
  # before_action :enough_credit?, only: [:create]

  def index
    @reservations = current_user.reservations.order(created_at: :desc)
    
    
  end
  

  def show
    @user = User.find(params[:user_id])
    @workouts = Workout.where(host_id: @user.id).order(created_at: :desc)
    
  end
  
  def create
    puts "#"*50
    puts "Je suis dans create de reservations_controller.rb"
    puts params
    puts reservation_params
    puts reservation_params[:workout_id]
    puts "#"*50
    #create a reservation to pre-reserve a place, be careful, if the host doesn't refuse, the place is still reserved => need a conditoin to delete it after 48h ?
    @workout = Workout.find(reservation_params[:workout_id])
    @price = reservation_params[:workout_price].to_f
    @quantity = reservation_params[:quantity].to_i
    @total = @price * @quantity
    @reservation = Reservation.new(workout: @workout, user: current_user, quantity: @quantity, total: @total)
    #debit user
    @user = current_user
    @user.update(credit: @user.credit.to_f - @total)
    #change status to pending
    @reservation.status = "pending"
    if @reservation.save      
      puts "$"*50
      puts @reservation.status
      flash[:notice] = "Votre réservation a bien été prise en compte. Nous avons procéder au débit de votre credit."
      #send email to host => this job is done by the model itself with the callback after_create
      #reserve paiement => paiement status = pending
      redirect_to @workout
    else
      flash[:alert] = @reservation.errors.full_messages.join(", ")
      redirect_to @workout
    end 

  end

  def edit
    @reservation = Reservation.find(params[:id])
    @user = @reservation.user
  end

  def update
    puts "#"*50
    puts "je suis dans update de reservations_controller.rb"
    puts params
    puts "#"*50
    @reservation = Reservation.find(params[:id])
    
    host_decision = params[:host_decision]
    user_decision = params[:user_decision]
    
    
    puts "$"*50
    puts @reservation.status

    #host_decision zone
    if host_decision == "accepted"
      @reservation.status = "accepted"
      if @reservation.save
        flash[:notice] = "La réservation a bien été acceptée. Nous prévenons l'utilisateur"
        #paiement status = pending
        #send email to user to notify => this job is done by the model itself with the callback after_update
      else
        flash[:error] = @reservation.errors.full_messages.join(", ")
      end
    elsif host_decision == "refused"
      @reservation.status = "refused"

      if @reservation.save
        #refund user
        refund_user(@reservation)
        flash[:notice] = "La réservation a bien été annulée. Nous avons procéder au remboursement de l'utilisateur."
      else 
        flash[:error] = @reservation.errors.full_messages.join(", ")
      end
      #send email to user to notify => this job is done by the model itself with the callback after_update

    # elsif host_decision == "host_cancelled"
    #   @reservation.status = "host_cancelled"
    #   @reservation.save
      #refund user
      #send email to user to notify => this job is done by the model itself with the callback after_update
    end

    #user_decision zone
    if user_decision == "user_cancelled"
      @reservation.status = "user_cancelled"

      if @reservation.save
        #refund user
        refund_user(@reservation)
        flash[:notice] = "La réservation a bien été annulée. Nous avons procéder au remboursement."
      else 
        flash[:error] = @reservation.errors.full_messages.join(", ")
      end      
      #send email to host to notify => this job is done by the model itself with the callback after_update
    elsif user_decision == "closed"
      @reservation.status = "closed"

      if @reservation.save
        #pay host => paiement status = paid
        @reservation.workout.host.update(credit: @reservation.workout.host.credit.to_f + @reservation.total)
        flash[:notice] = "La réservation a bien été cloturée. Nous avons procéder au paiement de l'hôte."
      else 
        flash[:error] = @reservation.errors.full_messages.join(", ")
      end
      
      #send email to host to notify => this job is done by the model itself with the callback after_update
      #send email to user to thank => this job is done by the model itself with the callback after_update

      #if user_decision == "relauched", the status is already "pending" so no need to change it
    end

    

    puts @reservation.status
    #puts params[:reservation][:user_rating]
   
    puts "$"*50
    puts "je suis devant la condition rating"
    if @reservation.status == "closed" && params[:reservation]
      if params[:reservation][:user_rating] != nil
        if @reservation.update(user_rating: params[:reservation][:user_rating])
          flash[:success] = "La note a été enregistrée avec succès."
        else
          flash[:error] = "Il y a eu un problème lors de l'enregistrement de la note."
          puts @reservation.errors.full_messages
        end
      
      end

      if params[:reservation][:user_comment] != nil
        if @reservation.update(user_comment: params[:reservation][:user_comment])
          flash[:success] = "Le commentaire a été enregistré avec succès."
        else
          flash[:error] = "Il y a eu un problème lors de l'enregistrement du commentaire."
          puts @reservation.errors.full_messages
        end
      end

      if params[:reservation][:host_rating] != nil
        if @reservation.update(host_rating: params[:reservation][:host_rating])
          flash[:success] = "Le commentaire a été enregistré avec succès."
        else
          flash[:error] = "Il y a eu un problème lors de l'enregistrement du commentaire."
          puts @reservation.errors.full_messages
        end
      end
    
      if params[:reservation][:host_comment] != nil
        if @reservation.update(host_comment: params[:reservation][:host_comment])
          flash[:success] = "Le commentaire a été enregistré avec succès."
        else
          flash[:error] = "Il y a eu un problème lors de l'enregistrement du commentaire."
          puts @reservation.errors.full_messages
        end
      end
    
    end

    
    redirect_to root_path
    
  end

  


  private



  #def reservation_params
   #params.require(:reservation).permit(:status, :host_comment, :user_comment, :host_rating, :user_rating, :host_decision, :user_decision)
       
  #end

  def is_host?
    if current_user.id != Reservation.find(params[:id]).workout.host_id
      redirect_to root_path
    end
  end

  def status_is_pending?
    puts "#"*50
    puts params
    puts  "#"*50
    @reservation = Reservation.find(params[:id])
    if @reservation.status != "pending"
      puts "$"*50
      puts "status is not pending"
      redirect_to root_path, notice: 'Vous avez déjà pris une décision pour cette réservation.'
    end
  end 

  def no_cache
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def reservation_params
    params.require(:reservation).permit(:workout_id, :quantity, :workout_price)
  end
  
  def enough_credit?
    @workout = Workout.find(reservation_params[:workout_id])
    @price = reservation_params[:workout_price].to_f
    @quantity = reservation_params[:quantity].to_i
    @total = @price * @quantity
    if current_user.credit < @total
      flash[:error] = "Vous n'avez pas assez de crédit pour réserver ce cours. Allez dans mon compte > Paiement/Credit"
      redirect_to @workout
    end
  end

  def refund_user(reservation)
    @reservation = reservation
    amont_to_refund = @reservation.total
    @reservation.user.update(credit: @reservation.user.credit.to_f + amont_to_refund)
  end

end
