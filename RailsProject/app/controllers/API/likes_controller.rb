module API
  # Controller which manage the transaction for the Likes objects
  # Here is the list of action available :
  #
  # * save       	[post] - SECURE
  # * destroy     [get] - SECURE
  #
  class LikesController < ApisecurityController
  	# Destroy a specific object by its id
    #
    # Route : /likes/destroy
    #
    # ==== Options
    # 
    # * +like [typeObj]+ - Model name of the object to add to the like -> "News" | "Albums" | "Concerts"
    # * +like [obj_id]+ - ID of the object linked to the like
    # 
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, there is nothing to return
    # - +401+ - It is not a secured transaction
    # - +404+ - The like was not found
    # - +503+ - Error from server
    # 
    def destroy
      obj = nil
      begin
      	if (@security && ["News", "Albums", "Concerts"].include?(@like[:typeObj]))
      	  
          case @like[:typeObj]
          when "Albums"
            obj = Albumslike.where(user_id: @user_id).where(album_id: @like[:obj_id]).first
          when "Concerts"
            obj = Concertslike.where(user_id: @user_id).where(concert_id: @like[:obj_id]).first
          when "News"
            obj = Newslike.where(user_id: @user_id).where(news_id: @like[:obj_id]).first
          end

          if (obj == nil)
            codeAnswer 500
            defineHttp :forbidden
            sendJson and return
          end
      	  obj.destroy
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

    # Save a new object like. For more information on the parameters, check at the model
    # 
    # Route : /likes/save
    #
    # ==== Options
    # 
    # * +like [user_id]+ - Id of the user who has the like
    # * +like [typeObj]+ - Model name of the object to add to the like -> "News" | "Albums" | "Concerts"
    # * +like [obj_id]+ - ID of the object linked to the like
    # 
    # ===== HTTP VALUE
    # 
    # - +201+ - In case of success, return nothing
    # - +403+ - It is not a secured transaction
    # - +404+ - The object to like doesn't exist
    # - +409+ - You already like this
    # - +503+ - Error from server
    # 
    def save
      begin
        if (@security && @like[:user_id].to_i == @user_id.to_i && ["News", "Albums", "Concerts"].include?(@like[:typeObj]))
          obj = nil
          objLiked = nil
          classType = nil

          # Check if there is already a like
          case @like[:typeObj]
          when "Albums"
            obj = Albumslike.where(user_id: @user_id).where(album_id: @like[:obj_id]).first
          when "Concerts"
            obj = Concertslike.where(user_id: @user_id).where(concert_id: @like[:obj_id]).first
          when "News"
            obj = Newslike.where(user_id: @user_id).where(news_id: @like[:obj_id]).first
          end

          if (obj != nil)
            codeAnswer 503
            defineHttp :conflict
            sendJson and return
          end

          # Create a like
          case @like[:typeObj]
          when "Albums"
            obj = Albumslike.new
            objLiked = Album.find_by_id(@like[:obj_id])
            obj.album_id = @like[:obj_id]
          when "Concerts"
            obj = Concertslike.new
            objLiked = Concert.find_by_id(@like[:obj_id])
            obj.concert_id = @like[:obj_id]
          when "News"
            obj = Newslike.new
            objLiked = News.find_by_id(@like[:obj_id])
            obj.news_id = @like[:obj_id]
          end
          obj.user_id = @user_id
          obj.save

          if (objLiked == nil)
            codeAnswer 502
            defineHttp :not_found
          else
            codeAnswer 201
            defineHttp :created
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
  end
end