require 'open-uri'

module API
  # Controller which manage the transaction for the Suggestions objects
  # Here is the list of action available :
  #
  # * show        [get] - SECURE
  # * showTwo     [get] - SECURE OR NOT !
  # * getMusicalPast [post] - SECURE
  #
  class SuggestionsController < ApisecurityController
    # Give a list of music based on the purchases
    #
    # Route : /suggest
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return an array of music
    # - +401+ - It is not a secured transaction
    # - +404+ - Can't find musics to suggest
    # - +503+ - Error from server
    # 
    def show
      begin
        if (@security)
          u = User.find_by_id(@user_id)

          suggestion = Music.suggest(u)
          suggestArray = []

          suggestion.each { |music|
            suggestArray << JSON.parse(music.to_json(:only => Music.miniKey, :include => {
              album: { only: Album.miniKey },
              user: { only: User.miniKey }
            }))
          }

          if (!suggestion)
            codeAnswer 502
            defineHttp :not_found
          else
            @returnValue = { content: suggestArray.as_json }
            codeAnswer 200
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

    # Give a list of music based on the purchases
    #
    # Route : /suggestv2
    #
    # - +type+ - What do you want ? 'music' or 'artist' ?
    # - +limit+ - (optionnal) The limit of the list. Default : 30
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return an array of music
    # - +401+ - It is not a secured transaction
    # - +404+ - Can't find musics to suggest
    # - +503+ - Error from server
    # 
    def showTwo
      u = nil
      result = []
      limit = (@limit.present?) ? @limit.to_i : 30

      begin
        if (@security)
          u = User.find_by_id(@user_id)
        end

        if (@type.present? && @type == "artist")
          @returnValue = { content: User.suggestArtist(u, limit) }
          codeAnswer 200
        elsif (@type.present? && @type == "music")
          @returnValue = { content: Music.suggestMusic(u, limit) }
          codeAnswer 200
        else
          codeAnswer 504
          defineHttp :bad_request
        end

      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

    # Give a list of music based on the purchases
    #
    # Route : /musicalPast
    #
    # - +soundcloud_id+ - ID of the soundcloud user
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return nothing
    # - +401+ - It is not a secured transaction
    # - +403+ - The id has not been provided
    # - +404+ - Can't find anything with this id
    # - +503+ - Error from server
    # 
    def getMusicalPast
      begin
        if (!@soundcloud_id.present?)
            codeAnswer 504
            defineHttp :bad_request
        else
          if (@security)
            u = User.find_by_id(@user_id)
            g = Genre.all

            Identity.updateOrCreate(@user_id, 'soundcloud', @soundcloud_id)

            uri = URI.parse("https://api-v2.soundcloud.com/users/#{@soundcloud_id}/likes")
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            request = Net::HTTP::Get.new(uri.request_uri)
            response = http.request(request)
            hash = JSON.parse(response.body)['collection']

            soundcloud_ids = []
            soundcloud_objects = []

            hash.each do |x|
              soundcloud_ids << x['track']['id']
              soundcloud_objects << { soundcloud_id: x['track']['id'], genre: x['track']['genre'], title: x['track']['title'] }
            end

            past = Musicalpast.where(user_id: @user_id).where(soundcloud_music_id: soundcloud_ids).all
            past.each do |x|
              soundcloud_objects.each do |y|
                if (x.soundcloud_music_id == y[:soundcloud_id])
                  soundcloud_objects.delete(y)
                  break
                end
              end
            end

            soundcloud_objects.each do |o|
              g.each do |genre|
                if (o[:genre].downcase.include? genre.style_name.downcase)
                  mp = Musicalpast.new
                  mp.user_id = @user_id
                  mp.genre_id = genre.id
                  mp.soundcloud_music_id = o[:soundcloud_id]
                  mp.title = o[:title]
                  mp.save
                end
              end
            end

          else
            codeAnswer 500
            defineHttp :forbidden
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