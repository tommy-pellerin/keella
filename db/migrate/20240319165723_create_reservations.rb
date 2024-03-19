class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.belongs_to :workout, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
