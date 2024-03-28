class Reservation < ApplicationRecord
  before_create :workout_full?
  before_update :workout_full?, if: :status_changed_to_accepted?
  after_create :send_reservation_request
  after_update :send_email_on_condition

  belongs_to :user
  belongs_to :workout

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  validate :overlapping_reservations

  def overlapping_reservations
    # Get the start_date and end_date of the associated workout
    workout_start_date = self.workout.start_date
    workout_end_date = self.workout.end_date
  
    # Check if there are any existing reservations that overlap with the new one
    overlapping_reservations = Reservation.joins(:workout).where("reservations.user_id = ? AND reservations.workout_id != ? AND ((workouts.start_date <= ? AND workouts.end_date >= ?) OR (workouts.start_date <= ? AND workouts.end_date >= ?) OR (workouts.start_date >= ? AND workouts.end_date <= ?))", self.user_id, self.workout_id, workout_start_date, workout_start_date, workout_end_date, workout_end_date, workout_start_date, workout_end_date)
  
    # If there are any overlapping reservations, add an error
    if overlapping_reservations.any?
      errors.add(:base, "Cette séance chevauche une des séances que vous avez réservé.")
    end
  end

  def workout_full?
    @workout = self.workout
    @reservation_accepted = @workout.reservations.where(status: "accepted").sum(:quantity)
    if (@reservation_accepted + self.quantity) > @workout.participant_number
      errors.add(:base, "Il n'y a plus de places disponibles pour cette séance.")
      throw :abort
    end
  end

  private
  def status_changed_to_accepted?
    status_changed? && status == "accepted"
  end

  def send_reservation_request
    HostMailer.reservation_request(self).deliver_now
    # UserMailer.reservation_request(self).deliver_now
  end

  def send_accepted_email
    UserMailer.accepted_email(self).deliver_now
  end

  def send_refused_email
    UserMailer.refused_email(self).deliver_now
  end

  def workout_cancelled
    UserMailer.workout_cancelled(self).deliver_now
    if self.workout.reservations.order(:created_at).first == self
      HostMailer.workout_cancelled(self).deliver_now
    end
  end

  def reservation_cancelled
    HostMailer.reservation_cancelled(self).deliver_now
    UserMailer.reservation_cancelled(self).deliver_now
  end

  def send_evaluation
    UserMailer.evaluate_host(self).deliver_now
    HostMailer.evaluate_user(self).deliver_now
  end

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
      if self.host_rating == nil && self.host_comment ==nil && self.user_rating == nil && self.user_comment == nil
      send_evaluation
    end
    when "pending"
      send_reservation_request
    end
  end

  enum status: {
    pending: 0,
    accepted: 1,
    refused: 2,
    host_cancelled: 3,
    user_cancelled: 4,
    closed: 5,
    relaunched: 6
  }

end
