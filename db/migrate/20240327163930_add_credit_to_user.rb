class AddCreditToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :credit, :decimal, default: 0
  end
end
