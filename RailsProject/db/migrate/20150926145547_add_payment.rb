class AddPayment < ActiveRecord::Migration
  def change
    create_table(:paypal_payments) do |t|
			t.string 	:payment_method
			t.string 	:status
			t.string 	:payer_email
			t.string 	:payer_first_name
			t.string 	:payer_last_name
			t.string 	:payer_id
			t.string 	:payer_phone
			t.string 	:payer_country_code
			t.string 	:payer_street
			t.string 	:payer_city
			t.string 	:payer_postal_code
			t.string 	:payer_country_code
			t.string 	:payer_recipient_name
			t.integer :purchase_id

      t.timestamps
    end
  end
end
