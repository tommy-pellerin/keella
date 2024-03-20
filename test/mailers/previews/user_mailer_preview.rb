# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

    def reservation_email
        reservation = Reservation.first
        UserMailer.reservation_email(reservation)
    end

end
