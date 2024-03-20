class Reservation < ApplicationRecord
  after_create :set_pending_and_send_email

  
  def set_pending_and_send_email
    self.status = :pending
    self.save
    UserMailer.reservation_email(self).deliver_now
  end

  belongs_to :user
  belongs_to :workout

  enum status: {
    pending: 0,
    accepted: 1,
    refused: 2,
    cancelled: 3,
    closed: 4
  }

end
