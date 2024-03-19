class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  
  after_commit :welcome_send, if: :email_confirmed?

  def welcome_send
    UserMailer.welcome_email(self).deliver_now
  end
  
  private

  def email_confirmed?
    self.confirmed_at.present?
  end


end
