class AddTotalToReservation < ActiveRecord::Migration[7.1]
  def change
    add_column :reservations, :total, :decimal
  end
end
