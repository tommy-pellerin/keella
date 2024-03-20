class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.belongs_to :workout, index: true
      t.belongs_to :user, index: true
      t.integer :status
      t.text :host_comment
      t.text :user_comment
      t.integer :host_rating
      t.integer :user_rating

      t.timestamps
    end
  end
end
