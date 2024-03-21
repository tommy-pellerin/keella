# Preview all emails at http://localhost:3000/rails/mailers/host_mailer
class HostMailerPreview < ActionMailer::Preview
    
    def cancellation_notification
        reservation = Reservation.first # ou toute autre réservation que vous souhaitez utiliser pour la prévisualisation
        HostMailer.cancellation_notification(reservation)
    end


end
