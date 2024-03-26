class AddColumnToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :pseudo, :string
    add_column :users, :phone, :string
  end
end
