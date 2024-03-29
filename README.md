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

# Présentation de l'application
https://keella.fly.dev/

Plateforme de location en ligne qui met en relation des personnes souhaitant louer des équipements sportifs et des espaces pour pratiquer des activités sportives. Elle s’inspire du modèle d’Airbnb, mais se concentre spécifiquement sur le domaine sportif.

Les utilisateurs peuvent parcourir une variété d’équipements sportifs et d’espaces disponibles dans leur région ou dans un lieu qu’ils prévoient de visiter. Ils peuvent réserver et payer la location directement via l’application, ce qui offre une commodité et une sécurité similaires à celles d’Airbnb.

De plus, les personnes qui possèdent des équipements sportifs ou des espaces qu’elles n’utilisent pas tout le temps peuvent les inscrire sur l’application pour les louer à d’autres. C’est une excellente façon de monétiser ces ressources inutilisées.

En somme, votre application offre une solution pratique et économique pour les amateurs de sport, tout en créant une nouvelle source de revenus pour les propriétaires d’équipements et d’espaces sportifs.

# Technologies utilisées
Ruby on Rails 7 : C’est le framework principal utilisé pour le développement de l’application.
PostgreSQL : C’est le système de gestion de base de données utilisé.
Bootstrap : C’est le framework CSS utilisé pour le design front-end.

# Fonctionnalités
Note/Commentaire : Les utilisateurs peuvent laisser des notes ou des commentaires.
Hotwire : Utilisé pour une expérience utilisateur moderne et rapide (turbo frame).
Opendys : Bouton police de caractères spécialement développée pour les personnes dyslexiques.
Page Canonique : Mise en place de pages canoniques pour améliorer le SEO.
Paiement avec Stripe et système de crédit : Les utilisateurs peuvent effectuer des paiements via Stripe.
Système de mail : Les utilisateurs reçoivent des mails pour l’inscription, la réservation, le paiement, etc.
Intégration d’image Active Storage Amazon AWS S3 : Les images sont stockées sur Amazon AWS S3.
POO MVC : Le projet suit le paradigme de la Programmation Orientée Objet et l’architecture Modèle-Vue-Contrôleur.


# Inscription/Utilisation
Inscription : 
Tout d’abord, vous devez vous inscrire sur notre site. Créez un compte en fournissant vos informations de base. Une fois inscrit, vous pourrez accéder à toutes les fonctionnalités.

Recherche et Réservation :
Parcourez les sessions sportives disponibles. Vous pouvez rechercher par type d’activité, emplacement, date, etc.
Lorsque vous trouvez une session qui vous intéresse, réservez-la ! Vous devrez utiliser le système de crédit pour effectuer la réservation. Votre crédit sera débité du montant correspondant à la session réservée.
Vous recevrez une confirmation de réservation par e-mail.

Système de Crédit :
Notre système de crédit facilite les paiements. Vous pouvez recharger votre compte avec des crédits (Stripe mode test).
Chaque session sportive a un prix en crédits. Lorsque vous réservez une session, le montant correspondant est déduit de votre solde de crédit.

Création de Sessions (pour les Hôtes) :
Si vous êtes un hôte, vous pouvez créer vos propres sessions sportives ! Proposez des activités, choisissez le nombre de participants, fixez le prix en crédits et définissez les détails.
Les utilisateurs intéressés pourront réserver vos sessions.


# Pour obtenir le status de paiement on peux utiliser les conditoins :
if status = pending ou accepted -> paiement_status = pending
if status = refused ou cancelled -> paiement_status = refunded
if status = closed -> paid

# Email
Pour pointer vers l'action update dans votre contrôleur, vous devez utiliser une méthode HTTP PATCH ou PUT. Cependant, dans un email, vous ne pouvez pas créer de lien qui effectue une requête PATCH ou PUT directement, car les liens dans les emails ne peuvent que déclencher des requêtes GET.

Une solution courante à ce problème est de créer une page de confirmation intermédiaire. Lorsque l'utilisateur clique sur le lien dans l'email, il est redirigé vers une page de confirmation. Sur cette page, l'utilisateur peut alors cliquer sur un bouton qui effectue la requête PATCH ou PUT.



# Important concernant la page reservation edit
Pour empêcher l'utilisateur de revenir à la page précédente en utilisant le bouton de retour du navigateur, vous pouvez utiliser une technique appelée "PRG Pattern" (Post/Redirect/Get). Cela signifie que après une action POST (comme une mise à jour), vous redirigez l'utilisateur vers une autre page au lieu de simplement rendre une vue. Cela empêche l'utilisateur de soumettre à nouveau le formulaire en utilisant le bouton de retour du navigateur.

Cependant, cela ne résout pas complètement votre problème car l'utilisateur peut toujours utiliser le bouton de retour pour revenir à la page d'édition. Pour résoudre ce problème, vous pouvez désactiver la mise en cache de la page d'édition. Cela signifie que lorsque l'utilisateur essaie de revenir à la page d'édition, le navigateur devra demander à nouveau la page au serveur, ce qui déclenchera votre redirection.

Cela ajoutera les en-têtes HTTP nécessaires pour désactiver la mise en cache de la page d'édition. Lorsque l'utilisateur essaie de revenir à la page d'édition en utilisant le bouton de retour du navigateur, le navigateur demandera à nouveau la page au serveur, ce qui déclenchera votre redirection si le statut de la réservation n'est pas "pending".

