class AddPaymentId < ActiveRecord::Migration
  def change
  	add_column :paypal_payments, :payment_id, :string
  end
end
