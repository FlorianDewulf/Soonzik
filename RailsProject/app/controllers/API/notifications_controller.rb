module API
  # Controller which manage the transaction for the Notifications objects
  # Here is the list of action available :
  #
  # * show        [get] - SECURE
  # * save		    [post] - SECURE
  # * find        [get] - SECURE
  # * destroy     [get] - SECURE
  # * readNotif   [post] - SECURE
  #
  class NotificationsController < ApisecurityController
  	# Give a specific object by its id
    #
    # Route : /notifications/:id
    #
    # ==== Options
    # 
    # * +id+ - The id of the specific notification
    # 
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a notification including its user
    # - +404+ - Can't find the notification, the id is probably wrong
    # - +503+ - Error from server
    # 
    def show
      begin
      	if (@security)
	        notif = Notification.eager_load([:user, :from]).find_by_id(@id)
	        if (!notif || (notif && notif.user_id != @user_id))
	          codeAnswer 502
            defineHttp :not_found
          else
  	        @returnValue = { content: notif.as_json(:include => {
                                                                  :user => {:only => User.miniKey },
                                                                  :from => { :only => User.miniKey }
                                                                }, only: Notification.miniKey) }
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

    # Give a part of the notifications depending of the filter passed into parameter
    #
    # Route : /notifications/find
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
    #     http://api.soonzik.com/notifications/find?attribute[user_id]=1&order_by_desc[]=user_id&group_by[]=user_id
    #     Note : By default, if you precise no attribute, it will take every row
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a list of notifications including its user
    # - +503+ - Error from server
    # 
    def find
      begin
        if (!@security)
          codeAnswer 500
        else
          notification_object = Notification.eager_load([:user, :from]).where(user_id: @user_id)
          if (defined?@attribute)
            # - - - - - - - -
            @attribute.each do |x, y|
              condition = ""
              variable = y
              variable = false if y == "false"
              variable = true if y == "true"

              if (y[0] == "%" && y[-1] == "%")  #LIKE
                condition = ["'notifications'.? LIKE ?", %Q[#{x}], "%#{y[1...-1]}%"];
              else                              #WHERE
                condition = {x => variable};
              end

              if (notification_object == nil)
                notification_object = notification_object.where(condition)
              end
            end
          end

          order_asc = ""
          order_desc = ""
          # filter the order by asc to create the string
          if (defined?@order_by_asc)
            @order_by_asc.each do |x|
              order_asc += ", " if order_asc.size != 0
              order_asc += ("'notifications'." + %Q[#{x}] + " ASC")
            end
          end
          # filter the order by desc to create the string
          if (defined?@order_by_desc)
            @order_by_desc.each do |x|
              order_desc += ", " if order_desc.size != 0
              order_desc += ("'notifications'." + %Q[#{x}] + " DESC")
            end
          end

          if (order_asc.size > 0 && order_desc.size > 0)
            notification_object = notification_object.order(order_asc + ", " + order_desc)
          elsif (order_asc.size == 0 && order_desc.size > 0)
            notification_object = notification_object.order(order_desc)
          elsif (order_asc.size > 0 && order_desc.size == 0)
            notification_object = notification_object.order(order_asc)
          end

          if (defined?@group_by)    #group
            group = []
            @group_by.each do |x|
              group << %Q[#{x}]
            end
            notification_object = notification_object.group(group.join(", "))
          end

          if (defined?@limit)       #limit
            notification_object = notification_object.limit(@limit.to_i)
          end
          if (defined?@offset)      #offset
            notification_object = notification_object.offset(@offset.to_i)
          end

          @returnValue = { content: notification_object.as_json(:include => {
                                                                              :user => {:only => User.miniKey },
                                                                              :from => { :only => User.miniKey }
                                                                            }, only: Notification.miniKey) }

          if (notification_object.size == 0)
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

    # Destroy a specific object by its id
    #
    # ==== Options
    # 
    # * +id+ - The id of the specific notification
    # 
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return nothing
    # - +401+ - It is not a secured transaction
    # - +404+ - The notification was not found
    # - +503+ - Error from server
    # 
    def destroy
      begin
        if (@security)
          object = Notification.find_by_id(@id)
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

    # Set the notification as a read one
    #
    # Route : /notifications/:id/read
    #
    # ==== Options
    # 
    # * +id+ - The id of the specific notification
    # 
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return nothing
    # - +401+ - It is not a secured transaction
    # - +404+ - The notification was not found
    # - +503+ - Error from server
    # 
    def readNotif
      begin
        if (@security)
          object = Notification.find_by_id(@id)
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
          object.read = true
          object.save
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
  end
end