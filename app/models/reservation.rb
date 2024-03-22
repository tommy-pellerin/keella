class Reservation < ApplicationRecord
  before_create :workout_full?
  after_create :send_reservation_request
  after_update :send_email_on_condition

  belongs_to :user
  belongs_to :workout

  def workout_full?
    @workout = self.workout
    @reservation_accepted = @workout.reservations.where(status: "accepted")
    if @reservation_accepted.count >= @workout.participant_number
      errors.add(:base, "Il n'y a plus de places disponibles pour cette séance. Veuillez choisir une autre séance.")
      throw :abort
    end
  end

  def send_reservation_request
    HostMailer.reservation_request(self).deliver_now
  end

  def send_accepted_email
    UserMailer.accepted_email(self).deliver_now
  end

  def send_refused_email
    UserMailer.refused_email(self).deliver_now
  end

  def workout_cancelled
    UserMailer.workout_cancelled(self).deliver_now
    HostMailer.workout_cancelled(self).deliver_now
  end

  def reservation_cancelled
    HostMailer.reservation_cancelled(self).deliver_now
    UserMailer.reservation_cancelled(self).deliver_now
  end

  def send_evaluate_host
    UserMailer.evaluate_host(self).deliver_now
    HostMailer.evaluate_user(self).deliver_now
  end

  # def send_evaluate_user
  #   HostMailer.evaluate_user(self).deliver_now
  # end

  def send_email_on_condition
    case status
    when "accepted"
      send_accepted_email
    when "refused"
      send_refused_email
    when "host_cancelled"
      workout_cancelled
    when "user_cancelled"
      reservation_cancelled
    when  "closed"
      send_evaluate_host
      # send_evaluate_user
    end
  end

  enum status: {
    pending: 0,
    accepted: 1,
    refused: 2,
    host_cancelled: 3,
    user_cancelled: 4,
    closed: 5
  }

end
