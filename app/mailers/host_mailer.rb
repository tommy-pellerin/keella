class HostMailer < ApplicationMailer
  default from: ENV['MAILJET_NOREPLY_FROM']

  def reservation_request(reservation)
    #on récupère l'instance reservation pour ensuite pouvoir la passer à la view en @reservation
    @reservation = reservation
    @host = @reservation.workout.host
    @user = @reservation.user

    #on définit une variable @url qu'on utilisera dans la view d’e-mail
    @url  = 'http://keella.fly.dev' 

    # c'est cet appel à mail() qui permet d'envoyer l’e-mail en définissant destinataire et sujet.
    mail(to: @host.email, subject: 'Demande de reservation !') 
  end
end
