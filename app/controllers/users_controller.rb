class UsersController < ApplicationController
  before_action :authenticate_user!
  

  def index

  end
  
  def show
    @user = User.find(params[:id])
    @workouts = @user.hosted_workouts
    @average_user_rating = @user.reservations.average(:user_rating)
    @average_host_rating = @user.reservations.average(:host_rating)
    
  end

end
