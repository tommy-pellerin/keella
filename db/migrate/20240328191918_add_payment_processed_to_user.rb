class AddPaymentProcessedToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :payment_processed, :boolean, default: false
  end
end
