class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @number = rand(1..20)
    @nombre = rand(1..20)
  end

end
