class Workout < ApplicationRecord
  belongs_to :host, class_name: "User"
  belongs_to :city
  has_one :reservation
  has_one :user, through: :reservation

  validates :title,
    presence: true,
    length: { in: 5..140 }

  validates :description,
    presence: true,
    length: { in: 20..1000 }

  validates :start_date, presence: true
    validate :start_date_in_past?, on: [:create, :update] #verify that the start_date is not in the past

  validates :end_date, presence: true
    validate :end_date_after_start_date, on: [:create, :update] #verify that the end_date is after the start_date

  validates :price, presence: true #No more conditoin because the price can be free
  validates :location, presence: true
  validates :city, presence: true

  def duration
    (end_date - start_date).to_i
  end

  private

  def start_date_in_past?
    errors.add(:start_date, "ne peut pas être dans le passé") if start_date.present? && start_date <= Time.now
  end 

  def  end_date_after_start_date
    errors.add(:end_date, "doit être après la date de début") if end_date.present? && end_date <= start_date
  end
end
