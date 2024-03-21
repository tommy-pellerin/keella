class ReservationsController < ApplicationController
  def index
    @reservations = current_user.reservations.order(created_at: :desc)
  end

  
end
