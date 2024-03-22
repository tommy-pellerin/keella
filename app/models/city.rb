class City < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_by_full_name, against: [:name, :zip_code]
  
  has_many :workouts
  has_many :users
end
