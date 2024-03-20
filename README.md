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

#Utiliser enum avec
enum status: {
    pending: 0,
    accepted: 1,
    refused: 2,
    cancelled: 3 ou 2,
    closed: 4
  }

#Pour obtenir le statu de paiement on peux utiliser les conditoins :
if status = pending ou accepted -> paiement_status = pending
if status = refused ou cancelled -> paiement_status = refunded
if status = closed -> paid


Pour pointer vers l'action update dans votre contrôleur, vous devez utiliser une méthode HTTP PATCH ou PUT. Cependant, dans un email, vous ne pouvez pas créer de lien qui effectue une requête PATCH ou PUT directement, car les liens dans les emails ne peuvent que déclencher des requêtes GET.

Une solution courante à ce problème est de créer une page de confirmation intermédiaire. Lorsque l'utilisateur clique sur le lien dans l'email, il est redirigé vers une page de confirmation. Sur cette page, l'utilisateur peut alors cliquer sur un bouton qui effectue la requête PATCH ou PUT.