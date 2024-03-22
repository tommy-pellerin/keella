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
