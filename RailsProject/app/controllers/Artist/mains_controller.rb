module Artist
  # Controller which manage main page of the artist panel
  #
  class MainsController < ArtistsecurityController
  	# Root of the panel
  	def home
  		@menu = 'home'
  	end

  	###############
  	# AJAX ROUTES #
  	###############

  	# Ajax route to get the statistics (with .json at the end of the url) or it redirects to the root (if no .json)
  	def stats
  		respond_to do |format|
  			format.html { redirect_to artist_root_path }
        format.json {
        	if (@u == nil || (@u != nil && !@u.isArtist?))
        		codeAnswer 500
        		defineHttp :forbidden
        		sendJson and return
        	end

        	response = {
        		music: [],
        		album: [],
        		pack: [],
        		notes: {}
        	}

        	begin
	        	# Calculate the musics sell
	        	@u.musics.each { |music|
	        		purchasedItems = {
	        			music_title: music.title,
	        			total_sell: 0,
	        			lastweek: 0
	        		}
	        		music.purchased_musics.each { |purchased_music|
	        			if purchased_music.purchased_album == nil
		        			purchasedItems[:total_sell] += 1
		        			if ((Time.now.to_date - purchased_music.purchase.created_at.to_date).to_i > 7)
		        				purchasedItems[:lastweek] += 1
		        			end
	        			end
	        		}
	        		response[:music] << purchasedItems
	        	}
	        rescue
	        	response[:music] = [{
        			music_title: "A problem occured",
        			total_sell: 0,
        			lastweek: 0
	        	}]
	        end

        	begin
	        	# Calculate the albums sell
	        	@u.albums.each { |album|
	        		purchasedItems = {
	        			album_title: album.title,
	        			total_sell: 0,
	        			lastweek: 0
	        		}
	        		album.purchased_albums.each { |purchased_album|
	        			if purchased_album.purchased_pack == nil
		        			purchasedItems[:total_sell] += 1
		        			if ((Time.now.to_date - purchased_album.purchased_musics[0].purchase.created_at.to_date).to_i > 7)
		        				purchasedItems[:lastweek] += 1
		        			end
		        		end
	        		}
	        		response[:album] << purchasedItems
	        	}
	        rescue
	        	response[:album] = [{
        			album_title: "A problem occured",
        			total_sell: 0,
        			lastweek: 0
	        	}]
	        end

        	# Calculate the packs sell
        	memory_pack = {}

        	begin
	        	@u.albums.each { |album|
	        		album.packs.each { |pack|
	        			pack.purchased_packs.each { |purchased_pack|

		        			# if there is a pack and it was not defined before
		        			if !memory_pack.has_key?(pack.id) && purchased_pack.purchased_musics.size > 0
		        				memory_pack[pack.id] = {
				        			pack_title: pack.title,
				        			total_sell: 0,
				        			total_sell_partial: 0,
				        			lastweek: 0,
				        			lastweek_partial: 0,
				        			users: []
				        		}
			        		end

			        		# if the pack exist already and the user never buy it before
			        		if (!memory_pack[pack.id][:users].include?(@u.id)) && purchased_pack.purchased_musics.size > 0
			        			memory_pack[pack.id][:total_sell] += 1
		        				memory_pack[pack.id][:total_sell_partial] += 1 if purchased_pack.partial
			        			if ((Time.now.to_date - purchased_pack.purchased_musics[0].purchase.created_at.to_date).to_i > 7)
			        				memory_pack[pack.id][:lastweek] += 1
			        				memory_pack[pack.id][:lastweek_partial] += 1 if purchased_pack.partial
			        			end
			        			memory_pack[pack.id][:users] << purchased_pack.purchased_musics[0].purchase.user.id	        			
		        			end

	        			}
	        		}
	        	}

	        	memory_pack.each { |key, value|
	        		value.delete(:users)
	        		response[:pack] << value
	        	}
	        rescue
	        	response[:pack] = [{
	        		pack_title: "An error occured",
        			total_sell: 0,
        			total_sell_partial: 0,
        			lastweek: 0,
        			lastweek_partial: 0
	        	}]
	        end

					memory_notes = {
        		album: [],
        		average: 0
        	}
	        begin
	        	# Calculate the note statistics
	        	@u.albums.each { |album|

	        		# init
	        		album_to_insert = {
	        			musics: [],
	        			name: album.title,
	        			average: 0
	        		}
	        		notes = 0
	        		notesTotal = 0
	        		musicList = album.musics
	        		Music.fillAverageNote musicList

		        	musicList.each { |music|
	        			album_to_insert[:musics] << { id: music.id,
	        				name: music.title,
	        				note: music.getAverageNote
	        			}
	        			notes += 1
	        			notesTotal += music.getAverageNote
		        	}

		        	album_to_insert[:average] = notesTotal / notes if notes > 0
		        	memory_notes[:album] << album_to_insert if notes > 0
		        }

	        	notes = 0
	        	notesTotal = 0
	        	memory_notes[:album].each { |album|
	        		if album[:musics].size > 0
		        		notes += 1
		        		notesTotal += album[:average]
		        	end
	        	}
	        	memory_notes[:average] = notesTotal / notes if notes > 0
	        rescue
	        end
	        response[:notes] = memory_notes

        	render :json => response
        }
  		end
  	end

  	# Function to get the last comments about albums or musics
  	#
  	# ==== Options
  	#
  	# +:offset+ - The offset from where you want values
  	# +:limit+ - The number limit of values you want
  	#
  	def getLastComments
  		respond_to do |format|
  			format.html { redirect_to artist_root_path }
        format.json {
        	if (@u == nil || (@u != nil && !@u.isArtist?))
        		codeAnswer 500
        		defineHttp :forbidden
        		sendJson and return
        	end

        	offset = 0
        	limit = 5
		  		commentsTmp = []
		  		comments = []

		  		@u.albums.each { |album|
		  			commentsTmp += album.commentaries
		  		}

		  		commentsTmp.sort! { |x, y| y.created_at.to_date <=> x.created_at.to_date }

		  		offset = params[:offset].to_i if params.has_key?(:offset)
		  		limit = params[:limit].to_i if params.has_key?(:limit)

		  		commentsTmp = commentsTmp[offset..(offset+limit)]
		  		commentsTmp.each { |comment|
		  			comments << comment.as_json(:include => {
		  				:albums => { only: Album.miniKey },
		  				:user => { only: User.miniKey }
		  			}, only: Commentary.miniKey)
		  		}

        	render :json => comments
  			}
  		end
  	end

  	# Function to get the last comments about albums or musics
  	#
  	# ==== Options
  	#
  	# +:offset+ - The offset from where you want values
  	# +:limit+ - The number limit of values you want
  	#
  	def getLastTweets
  		respond_to do |format|
  			format.html { redirect_to artist_root_path }
        format.json {
        	if (@u == nil || (@u != nil && !@u.isArtist?))
        		codeAnswer 500
        		defineHttp :forbidden
        		sendJson and return
        	end

        	offset = 0
        	limit = 5
		  		
		  		offset = params[:offset].to_i if params.has_key?(:offset)
		  		limit = params[:limit].to_i if params.has_key?(:limit)

		  		tweets = Tweet.where("msg LIKE ?", "%@#{@u.username} %").offset(offset).limit(limit).as_json(:include => { :user => { only: User.miniKey } }, only: Tweet.miniKey + [:created_at])

        	render :json => tweets
  			}
  		end
  	end
  end
end