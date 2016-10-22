module API
  # Controller which manage the transaction for the Concerts objects
  # Here is the list of action available :
  #
  # * index       [get]
  # * show        [get]
  # * find        [get]
  #
  class ConcertsController < ApisecurityController
  	# Retrieve all the concerts
    #
    # Route : /concerts
    #
    # ==== Options
    # 
    # * +count+ - (optionnal) Get the number of object and not the object themselve. Useful for pagination
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a list of concerts including its address
    # - +503+ - Error from server
    # 
    def index
      begin
        if (@count.present? && @count == "true")
          @returnValue = { content: Concert.count }
        else
          concerts = Concert.eager_load([:address, :user]).all
          Concert.fillLikes concerts, @security, @user_id

          @returnValue = { content: concerts.as_json(:include => {
                                      :address => { :only => Address.miniKey  },
                                      :user => { :only => User.miniKey }
                                      }, :only => Concert.miniKey,
                                      :methods => [:likes, :hasLiked]) }
        end
        if (@returnValue[:content].size == 0)
          codeAnswer 202
        else
          codeAnswer 200
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

  	# Give a specific object by its id
    #
    # Route : concerts/:id
    #
    # ==== Options
    # 
    # * +id+ - The id of the specific concert
    # 
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a battle including its artists and the votes
    # - +404+ - Can't get the album, the id is probably wrong
    # - +503+ - Error from server
    # 
    def show
      begin
        concert = Concert.eager_load([:address, :user]).find_by_id(@id)
        if (!concert)
          codeAnswer 502
          defineHttp :not_found
        else
          Concert.fillLikes [concert], @security, @user_id
          @returnValue = { content: concert.as_json(:include => {
                                                            :address => { :only => Address.miniKey  },
                                                            :user => { :only => User.miniKey }
                                                            }, :only => Concert.miniKey,
                                                            :methods => [:likes, :hasLiked]) }
          codeAnswer 200
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

    # Give a part of the concerts depending of the filter passed into parameter
    #
    # Route : /concerts/find
    #
    # ==== Options
    # 
    # * +:attribute [attribute_name]+ - If you want a column equal to a specific value
    # * +:order_by_asc []+ - If you want to order by ascending by values
    # * +:order_by_desc []+ - If you want to order by descending by values
    # * +:group_by []+ - If you want to group by field
    # * +:limit+ - The number of row you want
    # * +:offset+ - The offset of the array
    # 
    # ==== Example
    #
    #     http://api.soonzik.com/concerts/find?attribute[address_id]=1&order_by_desc[]=url&group_by[]=url
    #     Note : By default, if you precise no attribute, it will take every row
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a list of battles including its artists and the votes
    # - +503+ - Error from server
    # 
    def find
      begin
        concert_object = nil
        if (defined?@attribute)
          # - - - - - - - -
          @attribute.each do |x, y|
            condition = ""
            if (y[0] == "%" && y[-1] == "%")  #LIKE
              condition = ["'concerts'.? LIKE ?", %Q[#{x}], "%#{y[1...-1]}%"];
            else                              #WHERE
              condition = {x => y};
            end

            if (concert_object == nil)          #concert_object doesn't exist
              concert_object = Concert.eager_load([:address, :user]).where(condition)
            else                              #concert_object exists
              concert_object = concert_object.where(condition)
            end
          end
          # - - - - - - - -
        else
          concert_object = Concert.eager_load([:address, :user]).all            #no attribute specified
        end

        order_asc = ""
        order_desc = ""
        # filter the order by asc to create the string
        if (defined?@order_by_asc)
          @order_by_asc.each do |x|
            order_asc += ", " if order_asc.size != 0
            order_asc += ("'concerts'." + %Q[#{x}] + " ASC")
          end
        end
        # filter the order by desc to create the string
        if (defined?@order_by_desc)
          @order_by_desc.each do |x|
            order_desc += ", " if order_desc.size != 0
            order_desc += ("'concerts'." + %Q[#{x}] + " DESC")
          end
        end

        if (order_asc.size > 0 && order_desc.size > 0)
          concert_object = concert_object.order(order_asc + ", " + order_desc)
        elsif (order_asc.size == 0 && order_desc.size > 0)
          concert_object = concert_object.order(order_desc)
        elsif (order_asc.size > 0 && order_desc.size == 0)
          concert_object = concert_object.order(order_asc)
        end

        if (defined?@group_by)    #group
          group = []
          @group_by.each do |x|
            group << %Q[#{x}]
          end
          concert_object = concert_object.group(group.join(", "))
        end

        if (defined?@limit)       #limit
          concert_object = concert_object.limit(@limit.to_i)
        end
        if (defined?@offset)      #offset
          concert_object = concert_object.offset(@offset.to_i)
        end

        Concert.fillLikes concert_object, @security, @user_id

        @returnValue = { content: concert_object.as_json(:include => {
                                                            :address => { :only => Address.miniKey  },
                                                            :user => { :only => User.miniKey }
                                                            }, :only => Concert.miniKey,
                                                            :methods => [:likes, :hasLiked]) }

        if (concert_object.size == 0)
          codeAnswer 202
        else
          codeAnswer 200
        end

      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end
  end
end