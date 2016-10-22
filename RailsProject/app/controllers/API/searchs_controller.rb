module API
  # Controller which manage the search feature
  # There is only one 
  #
  # * search 	  [get]
  #
  class SearchsController < ApisecurityController
    # Search an element in our collection of content or for a specific object type
  	# 
  	# Route : /search
  	#
   	# ==== Options
   	# 
   	# * +offset+ - [Optionnal] Number where to begin the results (only with filter)
    # * +limit+ - [Optionnal] Number of result you want (only with filter)
    # * +query+ - What the user type
    # * +type+ - [Optionnal] artist, user, music, album or pack
    # 
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return an hash like this : { artist: array_of_artist, user: array_of_user, music: array_of_musics, album: array_of_albums, pack: array_of_packs }
    # - +400+ - Query is missing
    # - +503+ - Error from server
    # 
    def search
 	  	begin
 	  		if (!@query.present?)
		    	codeAnswer 504
		    	defineHttp :bad_request
 	  		else
		 	  	content = []
			    offset = 0
			    limit = nil
		    	offset = @offset if defined?@offset && @offset > 0
		    	limit = @limit if defined?@limit && @limit > 0
		    	if defined?@type
		    	  case @type
		    	    when "artist"
					  	content = User.joins(:groups).merge(Group.where(:name => "Artist")).where(["LOWER(users.username) LIKE ?", "%#{@query.downcase}%"])
				    when "user"
				    	groupArel = Group.arel_table
					  	content = User.joins('LEFT OUTER JOIN "groups_users" ON "groups_users"."user_id" = "users"."id" LEFT OUTER JOIN "groups" ON "groups"."id" = "groups_users"."group_id"').where(groupArel[:name].not_eq("Artist").or(groupArel[:name].eq(nil))).where(["LOWER(users.username) LIKE ?", "%#{@query.downcase}%"])
				    when "music"
					  	content = Music.eager_load([:user, :album]).where(["LOWER(musics.title) LIKE ?", "%#{@query.downcase}%"]).where.not(album_id: nil)
				    when "album"
					  	content = Album.eager_load([:user, :musics]).where(["LOWER(albums.title) LIKE ?", "%#{@query.downcase}%"])
					  	Album.fillLikes [content], @security, @user_id
				    when "pack"
					  	content = Pack.eager_load([albums: { user: {} }]).where(["LOWER(packs.title) LIKE ?", "%#{@query.downcase}%"])
				  end
				  content = content.offset(offset)
				  if (limit != nil)
				  	content = content.limit(limit)
				  end
				  case @type
	    	    	when "artist"
					  	content = { artist: JSON.parse(content.to_json(:only => User.miniKey )) }
				    when "user"
					  	content = { user: JSON.parse(content.to_json(:only => User.miniKey )) }
				    when "music"
					  	content = { music: JSON.parse(content.to_json(:only => Music.miniKey, :include => { user: { only: User.miniKey }, album: { only: Album.miniKey } } ) ) }
				    when "album"
					  	content = { album: JSON.parse(content.to_json(:only => Album.miniKey, :include => { user: { only: User.miniKey }, musics: { only: Music.miniKey } } ) ) }
				    when "pack"
					  	content = { pack: JSON.parse(content.to_json(:only => Pack.miniKey, :include => { albums: { only: Album.miniKey, :include => { user: { only: User.miniKey } } } } ) ) }
				  end
				else
		    		groupArel = Group.arel_table

					artist_result = User.joins(:groups).merge(Group.where(:name => "Artist")).where(["LOWER(users.username) LIKE ?", "%#{@query.downcase}%"])
					user_result = User.joins('LEFT OUTER JOIN "groups_users" ON "groups_users"."user_id" = "users"."id" LEFT OUTER JOIN "groups" ON "groups"."id" = "groups_users"."group_id"').where(groupArel[:name].not_eq("Artist").or(groupArel[:name].eq(nil))).where(["LOWER(users.username) LIKE ?", "%#{@query.downcase}%"])
					music_result = Music.eager_load([:user, :album]).where(["LOWER(musics.title) LIKE ?", "%#{@query.downcase}%"]).where.not(album_id: nil)
					album_result = Album.eager_load([:user, :musics]).where(["LOWER(albums.title) LIKE ?", "%#{@query.downcase}%"])
					pack_result = Pack.eager_load([albums: { user: {} }]).where(["LOWER(packs.title) LIKE ?", "%#{@query.downcase}%"])
					if (artist_result.size == 0 && user_result.size == 0 && music_result.size == 0 && album_result.size == 0 && pack_result.size == 0)
						content = []
						codeAnswer 202
					else
					  	artist_result = artist_result.offset(offset)
					  	user_result = user_result.offset(offset)
					  	music_result = music_result.offset(offset)
					  	album_result = album_result.offset(offset)
					  	pack_result = pack_result.offset(offset)
						if limit != nil
							artist_result = artist_result.limit(limit)
							user_result = user_result.limit(limit)
							music_result = music_result.limit(limit)
							album_result = album_result.limit(limit)
							pack_result = pack_result.limit(limit)
						end
						Album.fillLikes album_result.all, @security, @user_id
				    	content = {
					    	artist: JSON.parse(artist_result.to_json(:only => User.miniKey )),
					    	user: JSON.parse(user_result.to_json(:only => User.miniKey )),
					    	music: JSON.parse(music_result.to_json(:only => Music.miniKey, :include => { user: { only: User.miniKey }, album: { only: Album.miniKey } } ) ),
					    	album: JSON.parse(album_result.to_json(:only => Album.miniKey, :include => { user: { only: User.miniKey }, musics: { only: Music.miniKey } } ) ),
					    	pack: JSON.parse(pack_result.to_json(:only => Pack.miniKey, :include => { albums: { only: Album.miniKey, :include => { user: { only: User.miniKey } } } } ) )
					    }
				  	end
	    		end
    			@returnValue[:content] = content
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