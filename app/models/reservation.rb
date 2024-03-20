class Reservation < ApplicationRecord
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
