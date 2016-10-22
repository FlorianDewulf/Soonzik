module API
  # Controller which manage the transaction for the ambiances objects
  # Here is the list of action available :
  #
  # * index       [get]
  # * show        [get]
  #
  class AmbiancesController < ApisecurityController
    #
    # Retrieve all the ambiances
    #
    # Route : /ambiances
    #
    # ==== Options
    # 
    # * +count+ - (optionnal) Get the number of object and not the object themselve. Useful for pagination
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a list of ambiances
    # - +503+ - Error from server
    # 
    def index
      begin
        if (@count.present? && @count == "true")
          @returnValue = { content: Ambiance.count }
        else
          @returnValue = { content: Ambiance.all.as_json(:only => Ambiance.miniKey) }
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
    # Route : /ambiances/:id
    #
    # ==== Options
    # 
    # * +:id+ - The id of the specific ambiance
    # * +:offset+ - The offset of the musics of the ambiance (optionnal)
    # * +:limit+ - The limit of the musics of the ambiance (optionnal)
    # 
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return the ambiance including its music and the artist
    # - +404+ - Can't get the ambiance, the id is probably wrong
    # - +503+ - Error from server
    # 
    def show
      begin
        ambiance = Ambiance.eager_load(:musics).find_by_id(@id)
        if (!ambiance)
          codeAnswer 502
          defineHttp :not_found
        else
          offset = (@offset.present?) ? @offset.to_i : 0
          limit = (@limit.present?) ? @limit.to_i : 30

          music_ids = ambiance.musics.select('id')[offset...(offset + limit)]
          music_ids.map! { |music| music.id }

          ambiance = ambiance.as_json(:only => Ambiance.miniKey)
          ambiance[:musics] = Music.eager_load(:user, :album).where(id: music_ids).all.as_json(only: Music.miniKey, :include => {
            album: { only: Album.miniKey },
            user: { only: User.miniKey }
          })
          
          @returnValue = { content: ambiance }
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