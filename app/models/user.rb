class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  
  
  has_many :reservations
  has_many :reserved_workouts, through: :reservations, source: :workout
  has_many :hosted_workouts, foreign_key: 'host_id', class_name: 'Workout'
  belongs_to :city, optional: true
  has_one_attached :avatar

  validates :pseudo, presence: true
  validates :phone, presence: true, 
  format: { with: /\A(?:(?:\+|00)33[\s.-]{0,3}(?:\(0\)[\s.-]{0,3})?|0)[1-9](?:(?:[\s.-]?\d{2}){4}|\d{2}(?:[\s.-]?\d{3}){2})\z/, message: "please enter a valid french number" } #french phone number start with +33, 0033 or 0, following by 9 numbers that can be separate by space, dot or dash

  def average_rating
    ratings = reservations.pluck(:user_rating, :host_rating).flatten.compact
    return "Pas encore d'évaluation" if ratings.empty?
    (ratings.sum.to_f / ratings.size).round(3)
  end

  #pluck récupère les valeurs des colonnes user_rating & host_rating
  #flatten assemble les deux colonnes en une
  #compact supprime les élément nil des colonnes pour ne pas faire baisser la moyenne
  # sum additionne tous les élément du tableau ratings
  #/
  # size calcule le nombre d'élément dans le tableau
  
  def average_user_rating
    user_ratings = reservations.pluck(:user_rating).compact
    return "Pas encore d'évaluation" if user_ratings.empty?
    (user_ratings.sum.to_f / user_ratings.size).round(3)
  end

  #def average_host_rating
    #host_ratings = reservations.pluck(:host_rating).compact
    #return "Pas encore d'évaluation" if host_ratings.empty?
    #host_ratings.sum / host_ratings.size.to_f
  #end


  def after_confirmation
    welcome_send
  end
  
  def welcome_send
    UserMailer.welcome_email(self).deliver_now
  end

  
  private

  def email_confirmed?
    self.confirmed_at.present?
  end

  


end
