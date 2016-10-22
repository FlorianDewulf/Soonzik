module API
  # Controller which manage the transaction for the Messages objects
  # Here is the list of action available :
  #
  # * show        [get] - SECURE
  # * save		    [post] - SECURE
  # * find        [get] - SECURE
  # * conversation [get] - SECURE
  #
  class MessagesController < ApisecurityController
  	# Give a specific object by its id
    #
    # Route : /messages/:id
    #
    # ==== Options
    # 
    # * +id+ - The id of the specific message
    # 
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a message including its sender and receiver
    # - +401+ - It is not a secured transaction
    # - +404+ - Can't find the message, the id is probably wrong
    # - +503+ - Error from server
    # 
    def show
      begin
      	if (@security)
	        msg = Message.eager_load([:sender, :receiver]).find_by_id(@id)
	        if (!msg || (msg && (msg.user_id == @user_id || msg.dest_id == @user_id)))
	          codeAnswer 502
            defineHttp :not_found
	        else
  	        @returnValue = { content: msg.as_json(:include => {
          														:sender => { :only => User.miniKey },
          														:receiver => { :only => User.miniKey }
          													}, :only => Message.miniKey) }
            codeAnswer 200
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

    # Save a new object Message. For more information on the parameters, check at the model
    # 
    # Route : /messages/save
    #
    # ==== Options
    # 
    # * +message [user_id]+ - Id of the user who send the message
    # * +message [dest_id]+ - Id of the user who read the message
    # * +message [msg]+ - The text of the message
    # 
    # ===== HTTP VALUE
    # 
    # - +201+ - In case of success, return the new message
    # - +401+ - It is not a secured transaction
    # - +503+ - Error from server
    # 
    def save
      begin
        if (@security && @message[:user_id].to_i == @user_id.to_i)
          msg = Message.new(Message.message_params params)
          if (msg.save)
            Chatjob.create(message_id: msg.id)
            @returnValue = { content: msg.as_json(:include => {
                                    :sender => { :only => User.miniKey },
                                    :receiver => { :only => User.miniKey }
                                  }, :only => Message.miniKey) }
            codeAnswer 201
            defineHttp :created
          else
            @returnValue = { content: msg.errors.to_hash.to_json }
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

    # Give a part of the messages depending of the filter passed into parameter
    #
    # ==== Options
    # 
    # * +attribute [attribute_name]+ - If you want a column equal to a specific value
    # * +order_by_asc []+ - If you want to order by ascending by values
    # * +order_by_desc []+ - If you want to order by descending by values
    # * +group_by []+ - If you want to group by field
    # * +limit+ - The number of row you want
    # * +offset+ - The offset of the array
    # 
    # ==== Example
    #
    #     http://api.soonzik.com/messages/find?attribute[user_id]=1&order_by_desc[]=user_id&group_by[]=user_id
    #     Note : By default, if you precise no attribute, it will take every row
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a list of messages including its sender and receiver
    # - +503+ - Error from server
    # 
    def find
      begin
        if (!@security)
          codeAnswer 500
        else
          message_object = Message.eager_load([:sender, :receiver]).where("user_id = ? OR dest_id = ?", @user_id, @user_id)
          if (defined?@attribute)
            # - - - - - - - -
            @attribute.each do |x, y|
              condition = ""
              if (y[0] == "%" && y[-1] == "%")  #LIKE
                condition = ["'messages'.? LIKE ?", %Q[#{x}], "%#{y[1...-1]}%"];
              else                              #WHERE
                condition = {x => y};
              end

              if (message_object != nil)
                message_object = message_object.where(condition)
              end
            end
            # - - - - - - - -
          end

          order_asc = ""
          order_desc = ""
          # filter the order by asc to create the string
          if (defined?@order_by_asc)
            @order_by_asc.each do |x|
              order_asc += ", " if order_asc.size != 0
              order_asc += ("'messages'." + %Q[#{x}] + " ASC")
            end
          end
          # filter the order by desc to create the string
          if (defined?@order_by_desc)
            @order_by_desc.each do |x|
              order_desc += ", " if order_desc.size != 0
              order_desc += ("'messages'." + %Q[#{x}] + " DESC")
            end
          end

          if (order_asc.size > 0 && order_desc.size > 0)
            message_object = message_object.order(order_asc + ", " + order_desc)
          elsif (order_asc.size == 0 && order_desc.size > 0)
            message_object = message_object.order(order_desc)
          elsif (order_asc.size > 0 && order_desc.size == 0)
            message_object = message_object.order(order_asc)
          end

          if (defined?@group_by)    #group
            group = []
            @group_by.each do |x|
              group << %Q[#{x}]
            end
            message_object = message_object.group(group.join(", "))
          end

          if (defined?@limit)       #limit
            message_object = message_object.limit(@limit.to_i)
          end
          if (defined?@offset)      #offset
            message_object = message_object.offset(@offset.to_i)
          end

          @returnValue = { content: message_object.as_json(:include => {
                                      :sender => { :only => User.miniKey },
                                      :receiver => { :only => User.miniKey }
                                    }, :only => Message.miniKey) }

          if (message_object.size == 0)
            codeAnswer 202
          else
            codeAnswer 200
          end
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

    # To get 20 messages between 2 people
    #
    # Route : /messages/conversation/:id
    #
    # ==== Options
    # 
    # * +:id+ - Id of the person with who you speak
    # * +:offset+ - (optionnal) offset to get the message from a specific offset (by default : 0)
    # * +:lastMsg+ - (optionnal) The id of the oldest message you have in your historic to get the 20 messages before it (can't be used with offset). It is less optimized than the offset (need to browse the array of messages). If the id is not found, it is like if the parameter was not set
    # 
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a list of messages (index 0 = the oldest message)
    # - +503+ - Error from server
    # 
    def conversation
      begin
        if (@security)
          messages = []
          if (defined?@offset)
            messages = Message.where(user_id: [@user_id, @id]).where(dest_id: [@user_id, @id]).order(created_at: :desc).offset(@offset).limit(20).reverse.as_json(:only => Message.miniKey)
          elsif (defined?@lastMsg)
            tmp = Message.where(user_id: [@user_id, @id]).where(dest_id: [@user_id, @id]).order(created_at: :desc).as_json(:only => Message.miniKey)
            index = 0
            tmp.each_with_index { |message, i|
              if (message[:id] == @lastMsg)
                index = i
                break
              end
            }
            messages = tmp[index..(index + 20)].reverse
          else
            messages = Message.where(user_id: [@user_id, @id]).where(dest_id: [@user_id, @id]).order(created_at: :desc).limit(20).reverse.as_json(:only => Message.miniKey)
          end
          @returnValue = { content: messages }
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
  end
end