# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

    def reservation_accepted_email
      
        reservation = Reservation.first
        reservation.status = :accepted
        reservation.save
        UserMailer.reservation_accepted_email(reservation)
    end

end
