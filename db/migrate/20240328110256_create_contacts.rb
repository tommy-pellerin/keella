class CreateContacts < ActiveRecord::Migration[7.1]
  def change
    create_table :contacts do |t|
      t.string :issue
      t.text :message

      t.timestamps
    end
  end
end
