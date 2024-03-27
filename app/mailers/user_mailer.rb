class UserMailer < ApplicationMailer
  default from: ENV['MAILJET_NOREPLY_FROM']

  def welcome_email(user)
    #on récupère l'instance user pour ensuite pouvoir la passer à la view en @user
    @user = user 

    #on définit une variable @url qu'on utilisera dans la view d’e-mail
    @url  = 'http://keella.fly.dev'

    # c'est cet appel à mail() qui permet d'envoyer l’e-mail en définissant destinataire et sujet.
    mail(to: @user.email, subject: 'Bienvenue chez nous !') 
  end

  def payment_confirmation_email(user, payment_intent)
    @user = user
    @paid_amount = (payment_intent.amount_received.to_f/100)
    mail(to: @user.email, subject: 'Confirmation de votre paiement')
  end

  def accepted_email(reservation)
    @reservation = reservation
    @host = @reservation.workout.host
    @user = @reservation.user
    @workout = @reservation.workout
    mail(to: @user.email, subject: 'Bonne nouvelle, votre réservation a été acceptée')
  end

  def refused_email(reservation)
    @reservation = reservation
    @host = @reservation.workout.host
    @user = @reservation.user
    @workout = @reservation.workout
    mail(to: @user.email, subject: 'Mauvaise nouvelle, votre réservation a été refusée')
  end

  def evaluate_host(reservation)
    @reservation = reservation
    @host = @reservation.workout.host
    @user = @reservation.user
    @workout = @reservation.workout
    mail(to: @user.email, subject: 'Séance terminée, merci pour votre confiance')
  end

  def reservation_cancelled(reservation)
    @reservation = reservation
    @host = @reservation.workout.host
    @user = @reservation.user
    @workout = @reservation.workout
    mail(to: @user.email, subject: 'Confirmation de l\'annulation de la séance')
  end

  def workout_cancelled(reservation)
    @reservation = reservation
    @host = @reservation.workout.host
    @user = @reservation.user
    @workout = @reservation.workout
    mail(to: @user.email, subject: 'La séance a été annulée par son hote')
  end



end
