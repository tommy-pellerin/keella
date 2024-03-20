class CreateCities < ActiveRecord::Migration[7.1]
  def change
    create_table :cities do |t|
      t.string :name
      t.integer :zip_code

      t.timestamps
    end
  end
end
