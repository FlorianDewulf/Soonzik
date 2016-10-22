module API
  # Controller which manage the transaction for the Tweets objects
  # Here is the list of action available :
  #
  # * index       [get]
  # * show        [get]
  # * find        [get]
  # * save        [post] - SECURE
  # * destroy     [get] - SECURE
  # * flux        [get] - SECURE
  #
  class TweetsController < ApisecurityController
  	# Retrieve all the tweets
    #
    # Route : /tweets
    #
    # ==== Options
    # 
    # * +count+ - (optionnal) Get the number of object and not the object themselve. Useful for pagination
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a list of tweets including its user
    # - +503+ - Error from server
    # 
    def index
      begin
        if (@count.present? && @count == "true")
          @returnValue = { content: Tweet.count }
        else
          @returnValue = { content: Tweet.eager_load(:user).all.as_json(:include => {
                                                      :user => { only: User.miniKey }
                                                    }, :only => Tweet.miniKey) }
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
    # Route : /tweets/:id
    #
    # ==== Options
    # 
    # * +id+ - The id of the specific tweets
    # 
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a tweet including its user
    # - +404+ - Can't find the tweet, the id is probably wrong
    # - +503+ - Error from server
    # 
    def show
      begin
        tweets = Tweet.eager_load(:user).find_by_id(@id)
        if (!tweets)
          codeAnswer 502
          defineHttp :not_found
        else
          @returnValue = { content: tweets.as_json(:include => {
                                                      :user => { only: User.miniKey }
                                                    }, :only => Tweet.miniKey) }
          codeAnswer 200
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

    # Save a new object Tweet. For more information on the parameters, check at the model
    # 
    # Route : /tweets/save
    #
    # ==== Options
    # 
    # * +:tweet [user_id]+ - Id of the user who has the tweet
    # * +:tweet [msg]+ - The text of the tweet
    # 
    # ===== HTTP VALUE
    # 
    # - +201+ - In case of success, return the tweet saved
    # - +401+ - It is not a secured transaction
    # - +503+ - Error from server
    # 
    def save
      begin
        if (@security && @tweet[:user_id] == @user_id)
          tweet = Tweet.new(Tweet.tweet_params params)
          if (tweet.save)

            if (tweet.msg =~ /(@)(\w{3,40})/i)
              begin
                match =  /(@)(\w{3,40})/i.match(tweet.msg)
                if (tweet.user.username != $2 && User.find_by_username($2))
                  n = Notification.new
                  n.user_id = User.find_by_username($2).id
                  n.notif_type = "tweet"
                  n.from_user_id = @user_id
                  n.read = false
                  n.link = "/tweets/#{tweet.id}"
                  n.save
                end
              rescue
              end
            end

            @returnValue = { content: tweet.as_json(:include => {
                                                      :user => { only: User.miniKey }
                                                    }, :only => Tweet.miniKey) }
            codeAnswer 201
            defineHttp :created
          else
            @returnValue = { content: tweet.errors.to_hash.to_json }
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

    # Give a part of the tweets depending of the filter passed into parameter
    #
    # Route : /tweets/find
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
    #     http://api.soonzik.com/tweets/find?attribute[user_id]=1&order_by_desc[]=user_id&group_by[]=user_id
    #     Note : By default, if you precise no attribute, it will take every row
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a list of tweets including its user
    # - +503+ - Error from server
    # 
    def find
      begin
        tweet_object = nil
        if (defined?@attribute)
          # - - - - - - - -
          @attribute.each do |x, y|
            condition = ""
            if (y[0] == "%" && y[-1] == "%")  #LIKE
              condition = ["'tweets'.? LIKE ?", %Q[#{x}], "%#{y[1...-1]}%"];
            else                              #WHERE
              condition = {x => y};
            end

            if (tweet_object == nil)          #tweet_object doesn't exist
              tweet_object = Tweet.eager_load(:user).where(condition)
            else                              #tweet_object exists
              tweet_object = tweet_object.where(condition)
            end
          end
          # - - - - - - - -
        else
          tweet_object = Tweet.eager_load(:user).all            #no attribute specified
        end

        order_asc = ""
        order_desc = ""
        # filter the order by asc to create the string
        if (defined?@order_by_asc)
          @order_by_asc.each do |x|
            order_asc += ", " if order_asc.size != 0
            order_asc += ("'tweets'." + %Q[#{x}] + " ASC")
          end
        end
        # filter the order by desc to create the string
        if (defined?@order_by_desc)
          @order_by_desc.each do |x|
            order_desc += ", " if order_desc.size != 0
            order_desc += ("'tweets'." + %Q[#{x}] + " DESC")
          end
        end

        if (order_asc.size > 0 && order_desc.size > 0)
          tweet_object = tweet_object.order(order_asc + ", " + order_desc)
        elsif (order_asc.size == 0 && order_desc.size > 0)
          tweet_object = tweet_object.order(order_desc)
        elsif (order_asc.size > 0 && order_desc.size == 0)
          tweet_object = tweet_object.order(order_asc)
        end

        if (defined?@group_by)    #group
          group = []
          @group_by.each do |x|
            group << %Q[#{x}]
          end
          tweet_object = tweet_object.group(group.join(", "))
        end

        if (defined?@limit)       #limit
          tweet_object = tweet_object.limit(@limit.to_i)
        end
        if (defined?@offset)      #offset
          tweet_object = tweet_object.offset(@offset.to_i)
        end

        @returnValue = { content: tweet_object.as_json(:include => {
                                                      :user => { only: User.miniKey }
                                                    }, :only => Tweet.miniKey) }

        if (tweet_object.size == 0)
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

    # Destroy a specific object by its id
    #
    # Route : /tweets/destroy
    #
    # ==== Options
    # 
    # * +id+ - The id of the specific tweet
    # 
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return nothing
    # - +401+ - It is not a secured transaction
    # - +404+ - The Tweet was not found
    # - +503+ - Error from server
    # 
    def destroy
      begin
        if (@security)
          object = Tweet.find_by_id(@id)
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

    # Get your tweets and the tweet of your follows
    # 
    # Route : /tweets/flux
    # 
    # ==== Options
    # 
    # * +offset+ - The offset of your search. Default value : 0
    # * +limit+ - The number of tweets you want. Default value : 30
    #
    # ===== HTTP VALUE
    # 
    # - +201+ - In case of success, return the tweets
    # - +401+ - It is not a secured transaction
    # - +503+ - Error from server
    # 
    def flux
      begin
        if (@security)
          u = User.eager_load(tweets: { user: {} }).find_by_id(@user_id)
          tweets = []
          tweets |= u.tweets || []
          offset = (@offset.present?) ? @offset.to_i : 0
          limit = (@limit.present?) ? @limit.to_i : 30
          u.follows.each do |user|
            tweets |= user.tweets || []
          end
          tweets.sort_by { |obj| obj.created_at}
          tweets.reverse!
          @returnValue = {
            content: tweets.as_json(only: Tweet.miniKey, :include => {
              user: {
                only: User.miniKey }
              })[offset..(offset + limit)]
          }
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