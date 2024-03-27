class AddQuantityToReservations < ActiveRecord::Migration[7.1]
  def change
    add_column :reservations, :quantity, :integer
  end
end
