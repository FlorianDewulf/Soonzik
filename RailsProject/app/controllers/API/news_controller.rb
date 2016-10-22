module API
  # Controller which manage the transaction for the News objects
  # Here is the list of action available :
  #
  # * index       [get]
  # * show        [get]
  # * find        [get]
  # * addcomment  [post] - SECURITY
  # * getcomments [get]
  #
  class NewsController < ApisecurityController
  	# Retrieve all the news
    #
    # Route : /news
    #
    # ==== Options
    # 
    # * +count+ - (optionnal) Get the number of object and not the object themselve. Useful for pagination
    # * +language+ - (optionnal) To get the news of a specific language. Default : "EN"
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a list of news including its user (the author), the newstexts, the attachments and the tags
    # - +503+ - Error from server
    # 
    def index
      begin
        if (@count.present? && @count == "true")
          @returnValue = { content: News.count }
        else
          n = News.eager_load([:user, :attachments]).all
          n.each do |news|
            if @language.present?
              news.setLanguage @language
            end
          end
          News.fillLikes n, @security, @user_id
          @returnValue = { content: n.as_json(:include => {
                                                      :user => { :only => User.miniKey },
                                                      :attachments => { :only => Attachment.miniKey }
                                                    }, :only => News.miniKey, methods: [:title, :content, :likes, :hasLiked]) }
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
    # Route : /news/:id
    #
    # ==== Options
    # 
    # * +id+ - The id of the specific news
    # * +language+ - (optionnal) To get the news of a specific language. Default : "EN"
    # 
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a news including its user (the author), the newstacts, the attachments
    # - +404+ - Can't find the news, the id is probably wrong
    # - +503+ - Error from server
    # 
    def show
      begin
        news = News.eager_load([:user, :attachments]).find_by_id(@id)
        if (!news)
          codeAnswer 502
          defineHttp :not_found
        else
          news.setLanguage @language if @language.present?
          News.fillLikes [news], @security, @user_id
          @returnValue = { content: news.as_json(:include => {
                                                  :user => { :only => User.miniKey },
                                                  :attachments => { :only => Attachment.miniKey }
                                                }, :only => News.miniKey, methods: [:title, :content, :likes, :hasLiked]) }
          codeAnswer 200
        end
      rescue
        puts $!, $@
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

    # Give a part of the news depending of the filter passed into parameter
    #
    # Route : /news/find
    #
    # ==== Options
    # 
    # * +attribute [attribute_name]+ - If you want a column equal to a specific value
    # * +order_by_asc []+ - If you want to order by ascending by values
    # * +order_by_desc []+ - If you want to order by descending by values
    # * +group_by []+ - If you want to group by field
    # * +limit+ - The number of row you want
    # * +offset+ - The offset of the array
    # * +language+ - (optionnal) To get the news of a specific language. Default : "EN"
    # 
    # ==== Example
    #
    #     http://api.soonzik.com/news/find?attribute[type]=1&order_by_desc[]=date&group_by[]=date
    #     Note : By default, if you precise no attribute, it will take every row
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a list of news including its user (the author), the newstacts, the attachments
    # - +503+ - Error from server
    # 
    def find
      begin
        new_object = nil
        if (defined?@attribute)
          # - - - - - - - -
          @attribute.each do |x, y|
            condition = ""
            if (y[0] == "%" && y[-1] == "%")  #LIKE
              condition = ["'news'.? LIKE ?", %Q[#{x}], "%#{y[1...-1]}%"];
            else                              #WHERE
              condition = {x => y};
            end

            if (new_object == nil)          #new_object doesn't exist
              new_object = News.eager_load([:user, :attachments]).where(condition)
            else                              #new_object exists
              new_object = new_object.where(condition)
            end
          end
          # - - - - - - - -
        else
          new_object = News.eager_load([:user, :attachments]).all            #no attribute specified
        end

        order_asc = ""
        order_desc = ""
        # filter the order by asc to create the string
        if (defined?@order_by_asc)
          @order_by_asc.each do |x|
            order_asc += ", " if order_asc.size != 0
            order_asc += ("'news'." + %Q[#{x}] + " ASC")
          end
        end
        # filter the order by desc to create the string
        if (defined?@order_by_desc)
          @order_by_desc.each do |x|
            order_desc += ", " if order_desc.size != 0
            order_desc += ("'news'." + %Q[#{x}] + " DESC")
          end
        end

        if (order_asc.size > 0 && order_desc.size > 0)
          new_object = new_object.order(order_asc + ", " + order_desc)
        elsif (order_asc.size == 0 && order_desc.size > 0)
          new_object = new_object.order(order_desc)
        elsif (order_asc.size > 0 && order_desc.size == 0)
          new_object = new_object.order(order_asc)
        end

        if (defined?@group_by)    #group
          group = []
          @group_by.each do |x|
            group << %Q[#{x}]
          end
          new_object = new_object.group(group.join(", "))
        end

        if (defined?@limit)       #limit
          new_object = new_object.limit(@limit.to_i)
        end
        if (defined?@offset)      #offset
          new_object = new_object.offset(@offset.to_i)
        end

        if (@language.present?)
          new_object.each do |news|
            news.setLanguage @language
          end
        end

        News.fillLikes new_object, @security, @user_id

        @returnValue = { content: new_object.as_json(:include => {
                                                      :user => { :only => User.miniKey },
                                                      :attachments => { :only => Attachment.miniKey }
                                                    }, :only => News.miniKey, methods: [:title, :content, :likes, :hasLiked]) }

        if (new_object.size == 0)
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

    # Add a comment to a specific news. Need to be a secure transaction.
    #
    # Route : /news/addcomment/:id
    #
    # ==== Options
    #
    # * +:id+ - The id of the news where is the comment
    # * +:content+ - The content of the comment
    #
    # ===== HTTP VALUE
    # 
    # - +201+ - In case of success, return the comment
    # - +404+ - Can't find the news, the id is probably wrong
    # - +503+ - Error from server
    # 
    def addcomment
      begin
        if (@security)
          news = News.find_by_id(@id)

          if (!news)
            codeAnswer 502
            defineHttp :not_found
          else
            com = Commentary.new
            com.content = @content
            com.author_id = @user_id
            
            if (com.save)
              com.news << news
              @returnValue = { content: com.as_json(:only => Commentary.miniKey, :include => { user: { only: User.miniKey } }) }
              codeAnswer 201
              defineHttp :created
            else
              codeAnswer 503
              defineHttp :service_unavailable
            end
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

    # Get comments of a specific news.
    #
    # Route : /news/:id/comments
    #
    # ==== Options
    #
    # * +:id+ - The id of the news where is the comment
    # * +:offset+ - The offset of the comment array (default : 0)
    # * +:limit+ - The max size of the array (default : 20)
    # * +:order_reverse+ - If "true", you get the old first, the new last (default : false)
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return the array of comment
    # - +404+ - Can't find the news, the id is probably wrong
    # - +503+ - Error from server
    # 
    def getcomments
      order = "false"
      begin
        news = News.eager_load(commentaries: { user: {} }).find_by_id(@id)
        @offset = 0 if !@offset.present?
        @limit = 20 if !@limit.present?
        order = @order_reverse if @order_reverse.present?() && (@order_reverse == "true" || @order_reverse == "false")
        if (!news)
          codeAnswer 502
          defineHttp :not_found
        else
          comments = news.commentaries.to_a || []
          comments.reverse! if order == "true"
          comments = comments[(@offset.to_i)...(@offset.to_i + @limit.to_i)]
          refine_comments = []
          comments.each { |comment|
            refine_comments << comment.as_json(:only => Commentary.miniKey, :include => { user: { only: User.miniKey } })
          }
          @returnValue = { content: refine_comments }
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end
  end
end