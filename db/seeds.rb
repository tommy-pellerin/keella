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

10.times do 
  city = City.create!(name: Faker::Address.unique.city, zip_code: Faker::Address.unique.zip_code)
end

i=0
test_hosts = []
5.times do
  i += 1
  test_hosts << User.new(email: "host#{i}@yopmail.com", password: "azerty", password_confirmation: "azerty", city: City.all.sample, pseudo: Faker::Name.unique.first_name, phone: "060000000#{i}")
end
test_hosts.each do |test_host|
  test_host.skip_confirmation! #this will allow to create a user without the need of an email confirmation ask by devise
  test_host.save!
end


  i=0
  test_users = []
  5.times do
    i += 1
    test_users << User.new(email: "user#{i}@yopmail.com", password: "azerty", password_confirmation: "azerty", city: City.all.sample, pseudo: Faker::Name.unique.first_name, phone: "070000000#{i}")
  end
  test_users.each do |test_user|
    test_user.skip_confirmation! #this will allow to create a user without the need of an email confirmation ask by devise
    test_user.save!
  end


10.times do |count|
  workout =  Workout.create!(title: Faker::Sport.sport(include_ancient: true, include_unusual: true), start_date: Faker::Time.between_dates(from: Date.today + 1, to: Date.today + 3, period: :day), end_date: Faker::Time.between_dates(from: Date.today + 4, to: Date.today + 7, period: :day), description: Faker::Lorem.sentence(word_count: 10), price: Faker::Number.between(from: 0.0, to: 20.0).round(2), location: Faker::Address.full_address, host: test_hosts.sample, city: City.all.sample, participant_number: Faker::Number.between(from: 1, to: 10))
  workout.images.attach(
    Rails.root.join('app','assets','images','sport',"#{count}.jpg")
  )
end

10.times do 
 reservation = Reservation.create!(workout: Workout.all.sample, user: User.all.sample, status: 0, host_rating: Faker::Number.between(from: 1, to: 5), user_rating: Faker::Number.between(from: 1, to: 5), user_comment: Faker::Lorem.sentence(word_count: 10), host_comment: Faker::Lorem.sentence(word_count: 10))
end