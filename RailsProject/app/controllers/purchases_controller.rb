require 'paypal-sdk-rest'

class PurchasesController < ApplicationController

	include PayPal::SDK::REST

	def buyCart
		listInCart = Cart.joins(:musics).where(user_id: current_user.id) | Cart.joins(:albums).where(user_id: current_user.id)
		if (listInCart.size == 0)
			flash[:notice] = "Your cart is empty."
			redirect_to :root
			return
		end

		itemList = []
		amount = 0
		listInCart.each do |inCart|
			obj = nil
			if (inCart.musics.size != 0)
				obj = inCart.musics.first
			else
				obj = inCart.albums.first
			end
			itemList << {
        :name => obj.title,
        :sku => obj.class.to_s,
        :price => '%.2f' % obj.price,
        :currency => "EUR",
        :quantity => 1
      }
      amount += obj.price
		end

		makePayment({
	    :return_url => "http://lvh.me:3000/successCallback/cart",
	    :cancel_url => "http://lvh.me:3000/cancelCallback/cart"
	  }, itemList, '%.2f' % amount, "You are purchasing your cart #1")
	end

	def buyPack
		gift_to = User.find_by_id(params.has_key?(:gift) && params[:gift].to_i != 0 ? params[:gift] : current_user.id)
		if (user_signed_in? && gift_to && params.has_key?(:id) && params.has_key?(:amount) &&
				params.has_key?(:artist) && params.has_key?(:association) &&
				params.has_key?(:website) && (p = Pack.find_by_id(params[:id])) != nil &&
				params[:amount].to_f > p.minimal_price && params[:artist].to_f + params[:association].to_f + params[:website].to_f == 100)


			makePayment({
		    :return_url => "http://lvh.me:3000/successCallback/pack/#{p.id}?amount=#{params[:amount].to_f}&artist=#{params[:artist].to_f}&association=#{params[:association].to_f}&website=#{params[:website].to_f}&gift=#{gift_to.id}",
		    :cancel_url => "http://lvh.me:3000//cancelCallback/pack/#{p.id}"
		  }, [{
        :name => p.title,
        :sku => "Pack",
        :price => '%.2f' % params[:amount].to_f,
        :currency => "EUR",
        :quantity => 1
      }], '%.2f' % params[:amount].to_f, "The pack '#{p.title}' will help artists, associations and us.")
		else
			redirect_to :root
		end
	end

	# Cart payment

	def paymentCallbackCart
		payment = Payment.find(params[:paymentId])

		p = Purchase.new
    p.user_id = current_user.id
    p.save!

		cart = Cart.eager_load(albums: { musics: {} }).where(carts: { user_id: current_user.id })
		p.buyCart(cart)

		address = payment.payer.payer_info.shipping_address
		payer_info = payment.payer.payer_info

		paymentModel = PaypalPayment.create({
			payment_id: payment.id,
			payment_method: payment.payer.payment_method,
			status: payment.payer.status,
			payer_email: payment.payer.payer_info.email,
			payer_first_name: payment.payer.payer_info.first_name,
			payer_last_name: payment.payer.payer_info.last_name,
			payer_id: payment.payer.payer_info.payer_id,
			payer_phone: payment.payer.payer_info.phone,
			payer_country_code: payment.payer.payer_info.country_code,
			payer_street: payment.payer.payer_info.shipping_address.line1,
			payer_city: payment.payer.payer_info.shipping_address.city,
			payer_postal_code: payment.payer.payer_info.shipping_address.postal_code,
			payer_country_code: payment.payer.payer_info.shipping_address.country_code,
			payer_recipient_name: payment.payer.payer_info.shipping_address.recipient_name,
			purchase_id: p.id
		})

		cart.destroy_all

		redirect_to my_music_path
	end

	def cancelCallbackCart
		flash[:alert] = "You cancelled your payment"
		redirect_to carts_my_cart_path
	end

	# Pack payment

	def paymentCallbackPack
		gift_to = User.find_by_id(params.has_key?(:gift) && params[:gift].to_i != 0 ? params[:gift] : current_user.id)
		if (user_signed_in? && gift_to && params.has_key?(:id) && params.has_key?(:amount) &&
				params.has_key?(:artist) && params.has_key?(:association) &&
				params.has_key?(:website) && (p = Pack.find_by_id(params[:id])) != nil &&
				params[:amount].to_f > p.minimal_price && params[:artist].to_f + params[:association].to_f + params[:website].to_f == 100)

			payment = Payment.find(params[:paymentId])

			purch = Purchase.new
	    purch.user_id = gift_to.id
	    purch.save!
			purch.addPurchasedPackFromObject(p, (p.averagePrice > params[:amount].to_f), params[:artist], params[:association], params[:website], params[:amount], gift_to.id)

			address = payment.payer.payer_info.shipping_address
			payer_info = payment.payer.payer_info

			paymentModel = PaypalPayment.create({
				payment_id: payment.id,
				payment_method: payment.payer.payment_method,
				status: payment.payer.status,
				payer_email: payment.payer.payer_info.email,
				payer_first_name: payment.payer.payer_info.first_name,
				payer_last_name: payment.payer.payer_info.last_name,
				payer_id: payment.payer.payer_info.payer_id,
				payer_phone: payment.payer.payer_info.phone,
				payer_country_code: payment.payer.payer_info.country_code,
				payer_street: payment.payer.payer_info.shipping_address.line1,
				payer_city: payment.payer.payer_info.shipping_address.city,
				payer_postal_code: payment.payer.payer_info.shipping_address.postal_code,
				payer_country_code: payment.payer.payer_info.shipping_address.country_code,
				payer_recipient_name: payment.payer.payer_info.shipping_address.recipient_name,
				purchase_id: p.id
			})
			redirect_to my_music_path
		else
			flash[:alert] = "An error occured, please contact us if you have been debited"
			redirect_to :root
		end
	end

	def cancelCallbackPack
		p = Pack.find_by_id(params[:id])
		flash[:alert] = "An error occured while communicating with Paypal"
		redirect_to carts_my_cart_path if (p != nil)
		redirect_to :root if (p == nil)
	end

	###########################

	private
	def makePayment(redirection, itemList, amount, description)
		@payment = Payment.new({
		  :intent =>  "sale",
		  :payer =>  {
		    :payment_method =>  "paypal"
		  },
		  :redirect_urls => redirection,
		  :transactions =>  [{
		    :item_list => {
		      :items => itemList
		    },
		    :amount => {
		      :total => amount.to_s,
		      :currency => "EUR"
		    },
		    :description =>  description
		  }]
		})

		test = 0
		begin
			if @payment.create
			  # Redirect the user to given approval url
			  @redirect_url = @payment.links.find{|v| v.method == "REDIRECT" }.href.gsub("https://www.paypal", "https://www.sandbox.paypal")
				redirect_to @redirect_url
			else
			  render text: @payment.error.inspect
			end
		rescue
			if test == 0
				test += 1
				retry
			else
				flash[:alert] = "An error occured while communicating with Paypal"
			end
		end
	end
end