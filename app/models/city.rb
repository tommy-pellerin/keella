class City < ApplicationRecord
  has_many :workouts
  has_many :users
end
