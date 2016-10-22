module API
  # Controller which manage the transaction for the Carts objects
  # Here is the list of action available :
  #
  # * show        [get] - SECURE
  # * save       	[post] - SECURE
  # * destroy     [get] - SECURE
  #
  class CartsController < ApisecurityController
  	# Destroy a specific object by its id
    #
    # Route : /carts/destroy
    #
    # ==== Options
    # 
    # * +id+ - The id of the specific cart
    # 
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, there is nothing to return
    # - +401+ - It is not a secured transaction
    # - +404+ - The cart was not found
    # - +503+ - Error from server
    # 
    def destroy
      begin
      	if (@security)
      	  object = Cart.find_by_id(@id)
          if (!object)
            codeAnswer 502
            defineHttp :not_found
            sendJson and return
          end
          if (object.user_id != @user_id.to_i)
            codeAnswer 500
            defineHttp :forbidden
            sendJson and return
          end
      	  object.destroy
      	  codeAnswer 202
      	else
      	  codeAnswer 500
          defineHttp :forbidden
      	end
      rescue
      	codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

    # Save a new object Cart. For more information on the parameters, check at the model
    # 
    # Route : /carts/save
    #
    # ==== Options
    # 
    # * +cart [user_id]+ - Id of the user who has the cart
    # * +cart [typeObj]+ - Model name of the object to add to the cart -> "Music" | "Album"
    # * +cart [obj_id]+ - Id of the object
    # 
    # ===== HTTP VALUE
    # 
    # - +201+ - In case of success, return the new item
    # - +403+ - It is not a secured transaction
    # - +503+ - Error from server
    # 
    def save
      begin
        if (@security && @cart[:user_id] == @user_id)
          raise ArgumentError, 'user_id missing' if (!defined?@cart[:user_id])
          raise ArgumentError, 'typeObj missing' if (!defined?@cart[:typeObj] || (@cart[:typeObj] != "Music" && @cart[:typeObj] != "Album"))
          raise ArgumentError, 'obj_id missing' if (!defined?@cart[:obj_id])

          cart = Cart.new
          cart.user_id = @cart[:user_id]
          classObj = @cart[:typeObj].constantize
          obj = classObj.find_by_id(@cart[:obj_id])
          # check if the object exists
          if (obj != nil)

            if (cart.save)
              case @cart[:typeObj]
                when "Music"
                  if (obj.album_id == nil)
                    cart.destroy
                    raise ArgumentError, 'music not sell, missing album_id'
                  end
                  cart.musics << obj;
                when "Album"
                  cart.albums << obj;
              end
              @returnValue = { content: cart.as_json(:include => {
                                                      :musics => { :only => Music.miniKey(), :include => {
                                                          album: { :only => Album.miniKey() },
                                                          user: { :only => User.miniKey } 
                                                        } },
                                                      :albums => { :only => Album.miniKey(), :include => { 
                                                          user: { :only => User.miniKey }
                                                        } }
                                                    }, only: Cart.miniKey) }
              codeAnswer 201
              defineHttp :created
            else
              @returnValue = { content: cart.errors.to_hash.to_json }
              codeAnswer 503
              defineHttp :service_unavailable
            end
          else
            codeAnswer 503
            defineHttp :service_unavailable
          end
        else
          codeAnswer 500
          defineHttp :forbidden
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

    # Give a part of the carts depending of the filter passed into parameter
    #
    # Route : /carts/my_cart
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a list of cart items
    # - +401+ - It is not a secured transaction
    # - +503+ - Error from server
    # 
    def show
      begin
        if (!@security)
          codeAnswer 500
          defineHttp :forbidden
        else
          cart = Cart.eager_load([musics: { album: {}, user: {} }, albums: { user: {} }]).where(user_id: @user_id)
          if (cart.size == 0)
            codeAnswer 202
          else
            @returnValue = { content: cart.as_json(:include => {
                                                      :musics => { :only => Music.miniKey(), :include => {
                                                          album: { :only => Album.miniKey() },
                                                          user: { :only => User.miniKey } 
                                                        } },
                                                      :albums => { :only => Album.miniKey(), :include => { 
                                                          user: { :only => User.miniKey }
                                                        } }
                                                    }, only: Cart.miniKey) }
            codeAnswer 200
          end
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end
  end
end