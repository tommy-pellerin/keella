class Workout < ApplicationRecord
  belongs_to :host, class_name: "User"
  belongs_to :city
  has_one :reservation
  has_one :user, through: :reservation
end
