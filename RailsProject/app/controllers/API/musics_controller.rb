module API
  # Controller which manage the transaction for the Musics objects
  # Here is the list of action available :
  #
  # * index       [get]
  # * show        [get]
  # * find        [get]
  # * addcomment  [post] - SECURITY
  # * get         [get]
  # * addtoplaylist   [post] - SECURITY
  # * delfromplaylist [get] - SECURITY
  # * getcomments [get]
  # * getNotes    [get]
  #
  class MusicsController < ApisecurityController
    # Retrieve all the musics
    #
    # Route : /musics
    #
    # ==== Options
    # 
    # * +count+ - (optionnal) Get the number of object and not the object themselve. Useful for pagination
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a list of musics including its user, album and genre
    # - +503+ - Error from server
    # 
    def index
      begin
        if (@count.present? && @count == "true")
          @returnValue = { content: Music.where("album_id IS NOT NULL").count }
        else
          musics = Music.eager_load([:album, :genres, :user]).where("album_id IS NOT NULL").all
          Music.fillAverageNote musics
          @returnValue = { content: musics.as_json(:only => Music.miniKey, :include => {
                                                        :album => { :only => Album.miniKey },
                                                        :genres => { :only => Genre.miniKey },
                                                        :user => {:only => User.miniKey}
                                                      },
                                                      methods: :getAverageNote)}
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
    # ==== Options
    # 
    # * +id+ - The id of the specific music
    # 
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a music including its album, genres and user (artist)
    # - +404+ - Can't find the music, the id is probably wrong
    # - +503+ - Error from server
    # 
    def show
      begin
        music = Music.eager_load([:album, :genres, :user]).where("album_id IS NOT NULL").find_by_id(@id)
        if (!music)
          codeAnswer 502
          defineHttp :not_found
        else
          @returnValue = { content: music.as_json(:only => Music.miniKey, :include => {
                                                    :album => { :only => Album.miniKey },
                                                    :genres => { :only => Genre.miniKey },
                                                    :user => {:only => User.miniKey}
                                                  },
                                                  methods: :getAverageNote) }
          codeAnswer 200
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

    # Give a part of the albums depending of the filter passed into parameter
    #
    # Route : /musics/find
    #
    # ==== Options
    # 
    # * +:attribute [attribute_name]+ - If you want a column equal to a specific value
    # * +:order_by_asc[]+ - If you want to order by ascending by values
    # * +:order_by_desc[]+ - If you want to order by descending by values
    # * +:group_by[]+ - If you want to group by field
    # * +:limit+ - The number of row you want
    # * +:offset+ - The offset of the array
    # 
    # ==== Example
    #
    #     http://api.soonzik.com/musics/find?attribute[album_id]=1&order_by_desc[]=id&group_by[]=title
    #     Note : By default, if you precise no attribute, it will take every row
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a list of musics including its album, genres and user (artist)
    # - +503+ - Error from server
    # 
    def find
      begin
        music_object = nil
        puts "byPass present ? #{@bypass.present?}"
        byPass = (@bypass.present?) ? true : false
        if (defined?@attribute)
          # - - - - - - - -
          @attribute.each do |x, y|
            condition = ""
            if (y[0] == "%" && y[-1] == "%")  #LIKE
              condition = ["'musics'.? LIKE ?", %Q[#{x}], "%#{y[1...-1]}%"];
            else                              #WHERE
              condition = {x => y};
            end

            if (music_object == nil)          #music_object doesn't exist
              music_object = Music.eager_load([:album, :genres, :user, :ambiances]).where(condition)
              music_object = music_object.where("album_id IS NOT NULL") if !byPass
            else                              #music_object exists
              music_object = music_object.where(condition)
            end
          end
          # - - - - - - - -
        else
          music_object = Music.eager_load([:album, :genres, :user, :ambiances])
          music_object = music_object.where("album_id IS NOT NULL") if !byPass
          music_object = music_object.all            #no attribute specified
        end

        order_asc = ""
        order_desc = ""
        # filter the order by asc to create the string
        if (defined?@order_by_asc)
          @order_by_asc.each do |x|
            order_asc += ", " if order_asc.size != 0
            order_asc += ("'musics'." + %Q[#{x}] + " ASC")
          end
        end
        # filter the order by desc to create the string
        if (defined?@order_by_desc)
          @order_by_desc.each do |x|
            order_desc += ", " if order_desc.size != 0
            order_desc += ("'musics'." + %Q[#{x}] + " DESC")
          end
        end

        if (order_asc.size > 0 && order_desc.size > 0)
          music_object = music_object.order(order_asc + ", " + order_desc)
        elsif (order_asc.size == 0 && order_desc.size > 0)
          music_object = music_object.order(order_desc)
        elsif (order_asc.size > 0 && order_desc.size == 0)
          music_object = music_object.order(order_asc)
        end

        if (defined?@group_by)    #group
          group = []
          @group_by.each do |x|
            group << %Q[#{x}]
          end
          music_object = music_object.group(group.join(", "))
        end

        if (defined?@limit)       #limit
          music_object = music_object.limit(@limit.to_i)
        end
        if (defined?@offset)      #offset
          music_object = music_object.offset(@offset.to_i)
        end

        Music.fillAverageNote music_object

        @returnValue = { content: music_object.as_json(:only => Music.miniKey, :include => {
                                                        :album => { :only => Album.miniKey },
                                                        :genres => { :only => Genre.miniKey },
                                                        :ambiances => { :only => Ambiance.miniKey },
                                                        :user => {:only => User.miniKey}
                                                      },
                                                      methods: :getAverageNote) }

        if (music_object.size == 0)
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

    # Add a comment to a specific music. Need to be a secure transaction.
    #
    # Route : /musics/addcomment/:id
    #
    # ==== Options
    #
    # * +id+ - The id of the music where is the comment
    # * +content+ - The content of the comment
    #
    # ===== HTTP VALUE
    # 
    # - +201+ - In case of success, return the comment
    # - +404+ - Can't find the music, the id is probably wrong
    # - +503+ - Error from server
    # 
  	def addcomment
      begin
        if (@security)
          music = Music.find_by_id(@id)

          if (!music)
            codeAnswer 502
            defineHttp :not_found
          else
            com = Commentary.new
            com.content = @content
            com.author_id = @user_id
            
            if (com.save)
              com.musics << music
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

    # To get the mp3. It cuts the file depending the rights
    #
    # Route : /musics/get/:id
    #
    # ==== Options
    #
    # * +id+ - The id of the music where is the comment
    # * +download+ - (optionnal) If it's equal to "true", the header allows to download the file immediatly
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return the content of the mp3 file as raw format
    # - +404+ - Can't find the music, the id is probably wrong
    # - +503+ - Error from server
    # 
    def get
      buffer = ""
      music = nil
      file = ""
      begin
        cut = true

        # Find the music
        if (defined?@id)
          music = Music.where("album_id IS NOT NULL").find_by_id(@id)
        end
        if (music == nil)
          codeAnswer 502
          defineHttp :not_found
        else
          # If the transaction is secured, it means we maybe have buy the music
          if (@security || music.limited == false)
            u = User.find_by_id(@user_id)
            cut = false if (music.limited == false || (u != nil && u.purchased_musics.include?(music)))
          end

          file = music.file
          file = "cut_" + file if cut
          buffer = File.open(File.join(Rails.root, "app", "assets", "musics", music.album.user.id.to_s, "#{file}.mp3"), "rb").read
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      if (@download.present? && @download == "true")
        send_file(File.join(Rails.root, "app", "assets", "musics", music.album.user.id.to_s, "#{file}.mp3"), :type => 'audio/mpeg')
      else
        respond_to do |format|
          headers['Content-Length'] = buffer.size.to_s
          format.mp3 { render :text => buffer, :content_type => 'audio/mpeg' }
        end
      end
    end

    # To add a specific music to a playlist
    #
    # Route : /musics/addtoplaylist
    #
    # ==== Options
    #
    # * +id+ - The id of the music you want to add
    # * +playlist_id+ - The id of the playlist where you want to add a music 
    #
    # ===== HTTP VALUE
    # 
    # - +201+ - In case of success, return nothing
    # - +401+ - It is not a secured transaction
    # - +404+ - Can't find the music or the playlist, the id is probably wrong
    # - +503+ - Error from server
    # 
    def addtoplaylist
      begin
        if (@security)
          playlist = Playlist.eager_load(:musics).find_by_id(@playlist_id)
          music = Music.where("album_id IS NOT NULL").find_by_id(@id)
          if (playlist && music && playlist.user_id == @user_id.to_i && !playlist.musics.include?(music))
            playlist_obj = PlaylistObject.create(music_id: music.id, playlist_id: playlist.id, row_order: :last)
            playlist_obj.musics << music
            defineHttp :created
            codeAnswer 201
          else
            codeAnswer 502
            defineHttp :not_found
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

    # To add a specific music to a playlist
    #
    # Route : /musics/delfromplaylist
    #
    # ==== Options
    #
    # * +id+ - The id of the music you want to add
    # * +playlist_id+ - The id of the playlist where you want to add a music 
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return nothing
    # - +401+ - It is not a secured transaction
    # - +404+ - Can't find the music or the playlist, the id is probably wrong
    # - +503+ - Error from server
    # 
    def delfromplaylist
      begin
        if (@security)
          playlist = Playlist.eager_load(:musics).find_by_id(@playlist_id)
          music = Music.find_by_id(@id)
          if (playlist && music && playlist.user_id == @user_id.to_i && playlist.musics.include?(music))
            playlist_obj = PlaylistObject.where(playlist_id: @playlist_id).find_by_music_id(@id)
            playlist_obj.musics.delete(music)
            playlist_obj.destroy
            codeAnswer 200
          else
            codeAnswer 502
            defineHttp :not_found
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

    # Get comments of a specific musics.
    #
    # Route : /musics/:id/comments
    #
    # ==== Options
    #
    # * +:id+ - The id of the musics where is the comment
    # * +:offset+ - The offset of the comment array (default : 0)
    # * +:limit+ - The max size of the array (default : 20)
    # * +:order_reverse+ - If "true", you get the old first, the new last (default : false)
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return the array of comment
    # - +404+ - Can't find the music, the id is probably wrong
    # - +503+ - Error from server
    # 
    def getcomments
      order = "false"
      begin
        musics = Music.eager_load(:commentaries => { user: {} }).find_by_id(@id)
        @offset = 0 if !@offset.present?
        @limit = 20 if !@limit.present?
        order = @order_reverse if @order_reverse.present?() && (@order_reverse == "true" || @order_reverse == "false")
        if (!musics)
          codeAnswer 502
          defineHttp :not_found
        else
          comments = musics.commentaries.to_a || []
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

    # Get notes given for multiple musics.
    #
    # Route : /musics/getNotes
    #
    # ==== Options
    #
    # * +:user_id+ - An array of music id
    # * +:arr_id+ - An array of music id
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return an array of { music_id / note }
    # - +404+ - Can't find the music, the id is probably wrong
    # - +503+ - Error from server
    # 
    def getNotes
      value = []
      begin
        if (@user_id.present? && @arr_id.present? && User.find_by_id(@user_id) != nil)
          arr = JSON.parse(@arr_id)
          if !arr.is_a?(Array)
            codeAnswer 502
            defineHttp :bad_request
          else
            arr.each_with_index do |id, i|
              arr[i] = arr[i].to_i
            end
            notes = MusicNote.where(music_id: arr).where(user_id: @user_id).group(:music_id)
            notes.each do |note|
                value << { music_id: note.music_id, note: note.value }
            end
            @returnValue = { content: value }
          end
        else
          codeAnswer 502
          defineHttp :bad_request
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

    # Get notes given for multiple musics.
    #
    # Route : /musics/:id/note/:note
    #
    # ==== Options
    #
    # * +:id+ - The id of the music
    # * +:note+ - The note you give to the music
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return nothing
    # - +401+ - It is not a secured transaction
    # - +404+ - Can't find the music, the id is probably wrong
    # - +503+ - Error from server
    # 
    def setNotes
      begin
        if (@security)
          if (@id.present? && @note.present? && Music.find_by_id(@id) != nil && @note.to_i > 0 && @note.to_i <= 5)
            m = nil
            m = MusicNote.where(music_id: @id).find_by_user_id(@user_id)
            if m == nil
              m = MusicNote.new
              m.user_id = @user_id
              m.music_id = @id
            end
            m.value = @note
            if (m.save)
              defineHttp :created
              codeAnswer 201
            else
              codeAnswer 503
              defineHttp :service_unavailable
            end
          else
            codeAnswer 502
            defineHttp :bad_request
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