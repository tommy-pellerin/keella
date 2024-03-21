class Reservation < ApplicationRecord
  before_create :workout_full?
  after_create :send_reservation_request
  # after_update :send_email_on_condition

  belongs_to :user
  belongs_to :workout

  def workout_full?
    @workout = self.workout
    if @workout.reservations.count >= @workout.participant_number
      errors.add(:base, "Il n'y a plus de places disponibles pour cette séance. Veuillez choisir une autre séance.")
      throw :abort
    end
  end

  def send_reservation_request
    HostMailer.reservation_request(self).deliver_now
  end

  # def send_reservation_confirmation
  #   UserMailer.reservation_confirmed(self).deliver_now
  # end

  # def send_reservation_refused
  #   UserMailer.reservation_refused(self).deliver_now
  # end

  # def workout_cancelled
  #   UserMailer.reservation_cancelled(self).deliver_now
  # end

  # def send_email_on_condition
  #   case status
  #   when "accepted"
  #     send_reservation_confirmation
  #   when "refused"
  #     send_reservation_refused
  #   when "cancelled"
  #     reservation_cancelled
  #   end
  # end

  enum status: {
    pending: 0,
    accepted: 1,
    refused: 2,
    cancelled: 3,
    closed: 4
  }

end
