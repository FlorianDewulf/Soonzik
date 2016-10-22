require 'paypal-sdk-rest'

module API
  # Controller which manage the transaction for the Purchase objects
  # Here is the list of action available :
  #
  # * buycart       [post] - SECURE
  # * buypack		    [post] - SECURE
  #
  class PurchasesController < ApisecurityController
    include PayPal::SDK::REST
    
    # Buy the current cart and empty it
    # 
    # Route : /purchases/buycart
    #
    # ==== Options
    # 
    # - +paypal [:payment_id] + - The informations that paypal returns after a payment (PAY-xxxxxx)
    # 
    # ===== HTTP VALUE
    # 
    # - +201+ - In case of success, return the purchase created in this format : { user: {}, purchased_musics: { music: {}, purchased_album: { album : {}, purchased_pack: { partial: value, pack: {} } } } }
    # - +401+ - It is not a secured transaction
    # - +503+ - Error from server
    # 
    def buycart
      p = nil
      ret = { musics: [], albums: [] }

      if (!(@paypal.present?() && @paypal.has_key?(:payment_id)))
        codeAnswer 503
        defineHttp :bad_request
      else
        begin
          if (@security)
            p = Purchase.new
            p.user_id = @user_id
            p.save!

            cart = Cart.eager_load(albums: { musics: {} }).where(carts: { user_id: @user_id })
            list = p.buyCart(cart, false, true)

            if (list == false)
              p.destroy
              @returnValue = { content: nil }
              codeAnswer 202
            else
              if ((@paypal[:payment_id] =~ /PAY-[A-Za-z-0-9]/) != nil)
                payment = Payment.find(@paypal[:payment_id])

                address = payment.payer.payer_info.shipping_address
                payer_info = payment.payer.payer_info
                PaypalPayment.create({
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

              else
                request = `curl -s --insecure https://api-3t.sandbox.paypal.com/nvp -d "USER=florian.dewulf-facilitator_api1.gmail.com&PWD=QRN447MQJTK4HRLH&SIGNATURE=AFcWxV21C7fd0v3bYYYRCpSSRl31A1yXlnpAqjVHPd5zaswpjnCJg-6f&METHOD=GetTransactionDetails&VERSION=78&TransactionID=#{@paypal[:payment_id]}`
                if ((request =~ /PAYMENTSTATUS=Completed/) == nil)
                  raise
                end
              end

              list.each { |item|
                if (item.is_a?(Music))
                  ret[:musics] << item.as_json(:include => {:album => { only: Album.miniKey } })
                else
                  ret[:albums] << item.as_json(:include => {:musics => { only: Music.miniKey } })
                end
              }

              cart.destroy_all

              @returnValue = { content: ret }
              codeAnswer 201
              defineHttp :created
            end
          else
            codeAnswer 500
            defineHttp :forbidden
          end
        rescue
          if p != nil
            p.purchased_albums.destroy_all
            p.purchased_musics.destroy_all
            p.destroy
          end
          codeAnswer 504
          defineHttp :service_unavailable
        end
      end
      sendJson
    end
    
    # Buy the current cart and empty it
    # 
    # Route : /purchases/buypack
    #
    # ==== Options
    #
    # - +pack_id+ - The id of the pack purchased
    # - +amount+ - The donation
    # - +artist+ - The percentage for the artist
    # - +association+ - The percentage for the association
    # - +website+ - The percentage for the website
    # - +paypal [:payment_id] + - The informations that paypal returns after a payment (PAY-xxxxxx)
    # - +gift_user_id+ - (optionnal) If this is a gift
    # 
    # 
    # ===== HTTP VALUE
    # 
    # - +201+ - In case of success, return the purchase created in this format : { user: {}, purchased_musics: { music: {}, purchased_album: { album : {}, purchased_pack: { partial: value, pack: {} } } } }
    # - +401+ - It is not a secured transaction
    # - +403+ - The sum of the percentage != 100
    # - +503+ - Error from server
    # 
    def buypack
      objectToDelete = []
      gift_to = User.find_by_id(@gift_user_id.present? ? @gift_user_id : @user_id)
      if (!(@paypal.present?() && @paypal.has_key?(:payment_id)) || !gift_to)
        codeAnswer 503
        defineHttp :bad_request
      else
        begin
          if (@security)
            pack = Pack.find_by_id(@pack_id)
            if (pack == nil)
              codeAnswer 502
              defineHttp :not_found
            elsif @artist.to_f + @association.to_f + @website.to_f != 100 || @amount.to_f < pack.minimal_price
              codeAnswer 504
              defineHttp :bad_request
            else
              p = Purchase.new
              p.user_id = gift_to.id
              p.save!

              if ((@paypal[:payment_id] =~ /PAY-[A-Za-z-0-9]/) != nil)

                payment = Payment.find(@paypal[:payment_id])
                address = payment.payer.payer_info.shipping_address
                payer_info = payment.payer.payer_info
                PaypalPayment.create({
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
              else
                request = %x(curl -s --insecure https://api-3t.sandbox.paypal.com/nvp -d "USER=florian.dewulf-facilitator_api1.gmail.com&PWD=QRN447MQJTK4HRLH&SIGNATURE=AFcWxV21C7fd0v3bYYYRCpSSRl31A1yXlnpAqjVHPd5zaswpjnCJg-6f&METHOD=GetTransactionDetails&VERSION=78&TransactionID=#{@paypal[:payment_id]})
                if ((request =~ /PAYMENTSTATUS=Completed/) == nil)
                  raise
                end
              end

              p.addPurchasedPackFromObject(pack, (pack.averagePrice > @amount.to_f), @artist, @association, @website, @amount, gift_to.id)

              @returnValue = {
                content: pack.as_json(only: Pack.miniKey, :include => {
                  albums: {
                    only: Album.miniKey,
                    :include => {
                      musics: { only: Music.miniKey }
                    }
                  }
                })
              }
            end
          else
            codeAnswer 500
            defineHttp :forbidden
          end
        rescue
          p.destroy
          codeAnswer 504
          defineHttp :service_unavailable
        end
      end
      sendJson
    end
  end
end