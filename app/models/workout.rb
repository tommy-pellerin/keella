class Workout < ApplicationRecord
  belongs_to :host, class_name: "User"
  belongs_to :city
  has_many :reservations
  has_many :users, through: :reservations
  has_one_attached :image1
  has_one_attached :image2
  has_one_attached :image3

  validates :title,
    presence: true,
    length: { in: 4..140 }

  validates :description,
    presence: true,
    length: { in: 20..1000 }

  validates :start_date, presence: true
  validate :start_date_in_past?, on: [:create, :update] #verify that the start_date is not in the past

  validates :end_date, presence: true
  validate :end_date_after_start_date, on: [:create, :update] #verify that the end_date is after the start_date

  validates :price, 
    presence: true,
    numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1000 }

  validates :participant_number, 
    presence: true,
    numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 1000 }

  validates :location, presence: true
  validates :city, presence: true

  def duration
    (end_date - start_date).to_i
  end

  def places_available
    participant_number.to_i - reservations.where(status: ["accepted", "pending"]).count.to_i
  end
  
  def is_free
    self.price == 0
  end

  private

  def start_date_in_past?
    errors.add(:start_date, "ne peut pas être dans le passé") if start_date.present? && start_date <= Time.now
  end 

  def  end_date_after_start_date
    errors.add(:end_date, "doit être après la date de début") if end_date.present? && end_date <= start_date
  end

 

end
