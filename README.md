# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

I deactivate the mailer by default to use seeds, remind to reactivate it in environnement/development :
config.action_mailer.perform_deliveries = true

How to use User and Workout model :
to get all workouts reserved by user : user.reserved_workouts
to get all workouts posted by host : user.hosted_workouts
to get the host of the workout : workout.host
to get the user who reserved the workout : workout.user

Be careful of the validation conditions !
the start_date and end_date are not correct but can be use to see some data