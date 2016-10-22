module API
  # Controller which manage the transaction for the Playlists objects
  # Here is the list of action available :
  #
  # * show        [get]
  # * find        [get]
  # * save        [post] - SECURITY
  # * update      [post] - SECURITY
  # * destroy     [get] - SECURITY
  #
  class PlaylistsController < ApisecurityController
  	# Give a specific object by its id
    #
    # Route : /playlists/:id
    #
    # ==== Options
    # 
    # * +id+ - The id of the specific playlist
    # 
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a playlist including its musics (which includes its albums and artist) and user
    # - +404+ - Can't find the playlist, the id is probably wrong
    # - +503+ - Error from server
    # 
    def show
      begin
        playlist = Playlist.eager_load([musics: { user: {}, album: {} }, user: {}]).find_by_id(@id)
        if (!playlist)
          codeAnswer 502
          defineHttp :not_found
        else
          @returnValue = { content: playlist.as_json(:include => {
          														  :musics => {
                                          :only => Music.miniKey,
                                          :include => {
                                            :user => { :only => User.miniKey },
                                            :album => { :only => Album.miniKey }
                                          }
                                        },
                                        :user => { :only => User.miniKey }
          														},
                                      :only => Playlist.miniKey) }
          codeAnswer 200
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

    # Save a new object Playlist. For more information on the parameters, check at the model
    # 
    # Route : /playlists/save
    #
    # ==== Options
    # 
    # * +:playlist [user_id]+ - Id of the user who has the playlist
    # * +:playlist [name]+ - Name of the playlist
    # 
    # ===== HTTP VALUE
    # 
    # - +201+ - In case of success, return the saved object including its musics (which includes its albums and artist) and user
    # - +401+ - It is not a secured transaction
    # - +503+ - Error from server
    # 
    def save
      begin
        if (@security && @playlist[:user_id] == @user_id)
          playlist = Playlist.new(Playlist.playlist_params params)
          if (playlist.save)
            @returnValue = { content: playlist.as_json(:include => {
                                        :musics => {
                                          :only => Music.miniKey,
                                          :include => {
                                            :user => { :only => User.miniKey },
                                            :album => { :only => Album.miniKey }
                                          }
                                        },
                                        :user => { :only => User.miniKey }
                                      },
                                      :only => Playlist.miniKey) }
            codeAnswer 201
            defineHttp :created
          else
            @returnValue = { content: playlist.errors.to_hash.to_json }
            codeAnswer 503
            defineHttp :service_unavailable
          end
        else
          codeAnswer 500
          defineHttp :forbidden
        end
      rescue
        puts $!, $@
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

    # Save a new object Playlist. For more information on the parameters, check at the model
    # 
    # Route : /playlists/update
    #
    # ==== Options
    # 
    # * +id+ - Id of the playlist to modify
    # * +playlist [name]+ - Name of the playlist
    # * +playlist [music][]+ - Array of the id of the music in the playlist
    # 
    # ===== HTTP VALUE
    # 
    # - +201+ - In case of success, return the playlist created including its musics (which includes its albums and artist) and user
    # - +401+ - It is not a secured transaction
    # - +503+ - Error from server
    # 
    def update
      old_playlist = []
      begin
        if (@security)
          playlist = Playlist.eager_load([musics: { user: {}, album: {} }, user: {}]).find_by_id(@id)
          if (playlist != nil && playlist.user_id == @user_id.to_i)
            if (@playlist.present? && @playlist.has_key?(:music) && JSON.parse(@playlist[:music]).size > 0)
              playlist.playlist_objects.each do |item|
                item.musics = []
                old_playlist << item.music_id
                item.destroy
              end
              JSON.parse(@playlist[:music]).each_with_index do |music_id, i|
                music = Music.find_by_id(music_id)
                if (music != nil)
                  po = PlaylistObject.create({ playlist_id: playlist.id, music_id: music.id, row_order: i })
                  po.musics << music
                end
              end
              playlist = Playlist.eager_load([musics: { user: {}, album: {} }, user: {}]).find_by_id(@id)
            end
            playlist.name = @playlist[:name] if @playlist.present? && @playlist.has_key?(:name)
            if (playlist.save)
              @returnValue = { content: playlist.as_json(:include => {
                                        :musics => {
                                          :only => Music.miniKey,
                                          :include => {
                                            :user => { :only => User.miniKey },
                                            :album => { :only => Album.miniKey }
                                          }
                                        },
                                        :user => { :only => User.miniKey }
                                      },
                                      :only => Playlist.miniKey) }
              codeAnswer 201
              defineHttp :created
            else
              old_playlist.each do |music_id|
                PlaylistObject.create({ playlist_id: playlist.id, music_id: music_id })
              end
              codeAnswer 505
              defineHttp :service_unavailable
            end
          else
            codeAnswer 505
            defineHttp :service_unavailable
          end
        else
          codeAnswer 500
          defineHttp :forbidden
        end
      rescue
        old_playlist.each do |music_id|
          PlaylistObject.create({ playlist_id: playlist.id, music_id: music_id })
        end
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

    # Give a part of the playlist depending of the filter passed into parameter
    #
    # Route : /playlists/find
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
    #     http://api.soonzik.com/playlists/find?attribute[user_id]=1&order_by_desc[]=user_id&group_by[]=user_id
    #     Note : By default, if you precise no attribute, it will take every row
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a list of playlist including its musics (which includes its albums and artist) and user
    # - +503+ - Error from server
    # 
    def find
      begin
        playlist_object = nil
        if (defined?@attribute)
          # - - - - - - - -
          @attribute.each do |x, y|
            condition = ""
            if (y[0] == "%" && y[-1] == "%")  #LIKE
              condition = ["'playlists'.? LIKE ?", %Q[#{x}], "%#{y[1...-1]}%"];
            else                              #WHERE
              condition = {x => y};
            end

            if (playlist_object == nil)          #playlist_object doesn't exist
              playlist_object = Playlist.eager_load([musics: { user: {}, album: {} }, user: {}]).where(condition)
            else                              #playlist_object exists
              playlist_object = playlist_object.where(condition)
            end
          end
          # - - - - - - - -
        else
          playlist_object = Playlist.eager_load([musics: { user: {}, album: {} }, user: {}]).all            #no attribute specified
        end

        order_asc = ""
        order_desc = ""
        # filter the order by asc to create the string
        if (defined?@order_by_asc)
          @order_by_asc.each do |x|
            order_asc += ", " if order_asc.size != 0
            order_asc += ("'playlists'." + %Q[#{x}] + " ASC")
          end
        end
        # filter the order by desc to create the string
        if (defined?@order_by_desc)
          @order_by_desc.each do |x|
            order_desc += ", " if order_desc.size != 0
            order_desc += ("'playlists'." + %Q[#{x}] + " DESC")
          end
        end

        if (order_asc.size > 0 && order_desc.size > 0)
          playlist_object = playlist_object.order(order_asc + ", " + order_desc)
        elsif (order_asc.size == 0 && order_desc.size > 0)
          playlist_object = playlist_object.order(order_desc)
        elsif (order_asc.size > 0 && order_desc.size == 0)
          playlist_object = playlist_object.order(order_asc)
        end

        if (defined?@group_by)    #group
          group = []
          @group_by.each do |x|
            group << %Q[#{x}]
          end
          playlist_object = playlist_object.group(group.join(", "))
        end

        if (defined?@limit)       #limit
          playlist_object = playlist_object.limit(@limit.to_i)
        end
        if (defined?@offset)      #offset
          playlist_object = playlist_object.offset(@offset.to_i)
        end

        @returnValue = { content: playlist_object.as_json(:include => {
                                        :musics => {
                                          :only => Music.miniKey,
                                          :include => {
                                            :user => { :only => User.miniKey },
                                            :album => { :only => Album.miniKey }
                                          }
                                        },
                                        :user => { :only => User.miniKey }
                                      },
                                      :only => Playlist.miniKey) }

        if (playlist_object.size == 0)
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
    # Route : /playlists/destroy
    #
    # ==== Options
    # 
    # * +id+ - The id of the specific playlist
    # 
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return nothing
    # - +401+ - It is not a secured transaction
    # - +404+ - The playlist was not found
    # - +503+ - Error from server
    # 
    def destroy
      begin
        if (@security)
          object = Playlist.find_by_id(@id)
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
  end
end