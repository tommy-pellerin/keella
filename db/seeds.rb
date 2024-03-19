# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'
Faker::Config.locale = 'fr'

Reservation.destroy_all
Workout.destroy_all
User.destroy_all
City.destroy_all

  test_host= User.new(email: "host@yopmail.com", password: "azerty", password_confirmation: "azerty")
  test_host.skip_confirmation! #this will allow to create a user without the need of an email confirmation ask by devise
  test_host.save!

  test_user= User.new(email: "user@yopmail.com", password: "azerty", password_confirmation: "azerty")
  test_user.skip_confirmation! #this will allow to create a user without the need of an email confirmation ask by devise
  test_user.save!

20.times do 
  city = City.create!(name: Faker::Address.city, zip_code: Faker::Address.zip_code)
end

1.times do
  workout =  Workout.create!(title: Faker::Lorem.sentence(word_count: 3), start_date: Faker::Time.between_dates(from: Date.today + 1, to: Date.today + 7, period: :day), end_date: Faker::Time.between_dates(from: Date.today + 1, to: Date.today + 7, period: :day), description: Faker::Lorem.sentence(word_count: 10), price: Faker::Number.decimal(l_digits: 2), location: Faker::Address.full_address, host: test_host, city: City.all.sample)
end

 reservation = Reservation.create!(workout: Workout.all.sample, user: test_user)