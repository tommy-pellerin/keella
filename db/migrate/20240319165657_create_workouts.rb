class CreateWorkouts < ActiveRecord::Migration[7.1]
  def change
    create_table :workouts do |t|
      t.string :title
      t.datetime :start_date
      t.datetime :end_date
      t.text :description
      t.decimal :price
      t.string :location
      t.references :host, foreign_key: { to_table: :users }, index: true
      t.belongs_to :city, index: true

      t.timestamps
    end
  end
end
