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
