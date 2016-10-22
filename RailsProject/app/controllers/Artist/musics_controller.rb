module Artist
  # Controller which manage main page of the artist panel
  #
  class MusicsController < ArtistsecurityController
  	before_action :setMenu
  	include ::Multimedia

  	# For the menu bar
  	def setMenu
  		@menu = 'music'
  	end

		# The index page for the music management
  	def index
  	end

  	# The page to propose a music
  	def propose
  	end

  	##########
  	#  AJAX  #
  	##########

  	# Route to upload a music (with genres)
  	def uploadMusic
    	if (@u == nil || (@u != nil && !@u.isArtist?))
    		codeAnswer 500
    		defineHttp :forbidden
    		sendJson and return
    	end

  		error = false
  		m = nil
  		http = :ok
  		ambiances = []
  		genres = []
  		newFilename = nil
  		hasWritten = false

  		begin
  			if (params.has_key?(:music))
					p = JSON.parse(params[:music])
  				if (!params.has_key?(:file) || !p.has_key?("title") || !p.has_key?("price") || !p.has_key?("limited"))
	  				error = "Parameters missing"
					else
						p = {
							title: p["title"],
							price: p["price"],
							limited: p["limited"]
						}	  				
	  			end
	  		else
	  			error = "Parameters missing"
	  		end

				genres = JSON.parse(params[:genres]) if params.has_key?(:genres)
				ambiances = JSON.parse(params[:ambiances]) if params.has_key?(:ambiances)

	      if error == false && params[:file].content_type == "audio/mp3"
	        randomNumber = rand(1000..10000)
	        timestamp = Time.now.to_i
	        newFilename = Digest::SHA256.hexdigest("#{timestamp}--#{params[:file].original_filename}#{randomNumber}") + "-" + params[:file].original_filename.downcase.gsub(/[^0-9A-Za-z]/, '')

	        #check si le dossier existe
	        if (!Dir.exists? Rails.root.join('app', 'assets', 'musics', @u.id.to_s))
	        	Dir.mkdir Rails.root.join('app', 'assets', 'musics', @u.id.to_s).to_s
	        end

	        File.open(Rails.root.join('app', 'assets', 'musics', @u.id.to_s, newFilename), 'wb') do |f|
	          f.write(params[:file].tempfile.read)
	        end
	        hasWritten = true

	        cutObject = Multimedia::CutAudio.new(Rails.root.join('app', 'assets', 'musics', @u.id.to_s).to_s, newFilename)
	        
  				# new music object
	        parameters = ActionController::Parameters.new({ music: p })
	        m = Music.new(Music.music_params parameters)
	        m.file = newFilename
	        m.user_id = @u.id
	        m.duration = cutObject.determine_duration
	        if (m.save)
		        http = :created
						cutObject.determineStart(0)
						cutObject.determineEnd(30)
						cutObject.cut
						genres.each { |genre|
							begin
								g = Genre.find_by_id(genre)
								if g != nil
									g.musics << m
								end
							rescue
							end
						}
						ambiances.each { |ambiance|
							begin
								a = Ambiance.find_by_id(ambiance)
								if g != nil
									a.musics << m
								end
							rescue
							end
						}
		      else
		      	error = m.errors.full_messages
		      	File.delete Rails.root.join('app', 'assets', 'musics', @u.id.to_s, newFilename).to_s
		        http = :bad_request
		      end

	      else
	      	error = "Wrong file format" if error == false
	      	http = :bad_request
	      end
		  rescue
		  	error = true
		  	if hasWritten == true
					File.delete Rails.root.join('app', 'assets', 'musics', @u.id.to_s, newFilename).to_s
		  	end
		  	m.delete if m.id != nil
		  	http = :bad_request
		  end

  		render :json => { error: error, music: m.as_json(:include => { genres: {}, ambiances: {} }) }, :status => http
  	end

  	# Route to update a music. Usefull to change album too
  	def updateMusic
  		m = nil
  		http = :ok

    	if (@u == nil || (@u != nil && !@u.isArtist?))
    		codeAnswer 500
    		defineHttp :forbidden
    		sendJson and return
    	end

  		begin
	  		if (params.has_key?(:id) && params.has_key?(:music))
	  			m = Music.find_by_id(params[:id])
	  			if (m.user_id != @u.id)
	  				http = :bad_request
	  			else
		  			u = false
		  			u = m.update(Music.music_params params) if m.user_id == @u.id
		  			if (u == false)
		  				http = :bad_request
		  			else
		  				if (params.has_key?(:genres))
			  				m.genres = []
			  				params[:genres].each { |genre|
									begin
										g = Genre.find_by_id(genre)
										if g != nil
											g.musics << m
										end
									rescue
									end
								}
							end
		  				if (params.has_key?(:ambiances))
			  				m.ambiances = []
			  				params[:ambiances].each { |ambiance|
									begin
										g = Ambiance.find_by_id(ambiance)
										if g != nil
											g.musics << m
										end
									rescue
									end
								}
							end
							m.reload
		  			end
		  		end
	  		else
	  			http = :bad_request
	  		end
	  	rescue
	  		http = :bad_request
	  	end

  		render :json => { music: m.as_json(:include => { genres: {}, ambiances: {} }) }, :status => http
  	end

  	# Route to create an album
  	def uploadAlbum
  		error = false
  		a = nil
  		http = :ok
  		genres = []
  		descriptions = []

    	if (@u == nil || (@u != nil && !@u.isArtist?))
    		codeAnswer 500
    		defineHttp :forbidden
    		sendJson and return
    	end

  		begin
  			if (params.has_key?(:album))
					p = JSON.parse(params[:album])
  				if (!params.has_key?(:file) || !p.has_key?("title") || !p.has_key?("price") || !p.has_key?("yearProd"))
	  				error = "Parameters missing"
					else
						p = {
							title: p["title"],
							price: p["price"],
							yearProd: p["yearProd"]
						}	  				
	  			end
	  		else
	  			error = "Parameters missing"
	  		end

				genres = JSON.parse(params[:genres]) if params.has_key?(:genres)
				descriptions = self.parseDescriptions((params.has_key?(:descriptions)) ? JSON.parse(params[:descriptions]) : [], error)
				
				acceptedContentType = [
          "image/gif",
          "image/jpeg",
          "image/pjpeg",
          "image/png",
          "image/x-png"
        ]

				if error == false && acceptedContentType.include?(params[:file].content_type)
	        randomNumber = rand(1000..10000)
	        timestamp = Time.now.to_i
	        newFilename = Digest::SHA256.hexdigest("#{timestamp}--#{params[:file].original_filename}#{randomNumber}") + "-" + params[:file].original_filename.gsub(/[^0-9A-Za-z\.-]/, '')
  				
	        File.open(Rails.root.join('app', 'assets', 'images', 'albums', newFilename), 'wb') do |f|
	          f.write(params[:file].tempfile.read)
	        end

	        # new music object
	        parameters = ActionController::Parameters.new({ album: p })
	        a = Album.new(Album.album_params parameters)
	        a.image = newFilename
	        a.file = newFilename
	        a.user_id = @u.id
	        if (a.save)
						http = :created
						genres.each { |genre|
							begin
								g = Genre.find_by_id(genre)
								if g != nil
									g.albums << a
								end
							rescue
							end
						}
						descriptions.each { |description|
							begin
								d = Description.new
								d.description = description["description"]
								d.language = description["language"]
								if (d.save)
									a.descriptions << d
								end
							rescue
							end
						}
		      else
		      	error = m.errors.full_messages
		      	File.delete Rails.root.join('app', 'assets', 'images', 'albums', newFilename).to_s
		        http = :bad_request
		      end
	      else
	      	error = "Wrong file format" if error == false
	      	http = :bad_request
	      end
			rescue
		  	error = true
      	http = :bad_request
			end

  		render :json => { error: error, album: a.as_json(:include => { musics: {}, genres: {}, descriptions: {} } ) }, :status => http
  	end

  	# To update the album
  	# We can't change the file
  	def updateAlbum
  		error = false
  		a = nil
  		http = :ok
  		genres = []

    	if (@u == nil || (@u != nil && !@u.isArtist?))
    		codeAnswer 500
    		defineHttp :forbidden
    		sendJson and return
    	end

  		begin
  			if (params.has_key?(:album) && params.has_key?(:id))
					p = JSON.parse(params[:album])
					p[:title] = p["title"] if p.has_key?("title")
					p[:price] = p["price"] if p.has_key?("price")
					p[:yearProd] = p["yearProd"] if p.has_key?("yearProd")
	  		else
	  			error = "Parameters missing"
	  		end

				genres = JSON.parse(params[:genres]) if params.has_key?(:genres)
				descriptions = self.parseDescriptions((params.has_key?(:descriptions)) ? JSON.parse(params[:descriptions]) : [], error)

				acceptedContentType = [
          "image/gif",
          "image/jpeg",
          "image/pjpeg",
          "image/png",
          "image/x-png"
        ]

        a = Album.find_by_id(params[:id])

        if a != nil && a.user_id == @u.id && error == false && (!params.has_key?(:file) || (params.has_key?(:file) && acceptedContentType.include?(params[:file].content_type)))
        	oldFile = nil
        	newFilename = nil

        	if (params.has_key? :file)
		        randomNumber = rand(1000..10000)
		        timestamp = Time.now.to_i
		        newFilename = Digest::SHA256.hexdigest("#{timestamp}--#{params[:file].original_filename}#{randomNumber}") + "-" + params[:file].original_filename.gsub(/[^0-9A-Za-z\.-]/, '')
	  				
		        File.open(Rails.root.join('app', 'assets', 'images', 'albums', newFilename), 'wb') do |f|
		          f.write(params[:file].tempfile.read)
		        end

		        oldFile = a.image
		      end

	        # new music object
	        parameters = ActionController::Parameters.new({ album: p })
	        ret = a.update(Album.album_params parameters)
	        if (ret && newFilename != nil)
		        a.image = newFilename
		        a.file = newFilename
		        a.save!
		      end
	        if (ret)
	        	File.delete Rails.root.join('app', 'assets', 'images', 'albums', oldFile).to_s if oldFile != nil
						http = :created
						a.genres = []
						genres.each { |genre|
							begin
								g = Genre.find_by_id(genre)
								if g != nil
									g.albums << a
								end
							rescue
							end
						}
						a.descriptions = []
						descriptions.each { |description|
							begin
								d = Description.new
								d.description = description["description"]
								d.language = description["language"]
								if (d.save)
									a.descriptions << d
								end
							rescue
							end
						}
						a.reload
		      else
		      	error = m.errors.full_messages
		      	File.delete Rails.root.join('app', 'assets', 'images', 'albums', newFilename).to_s
		        http = :bad_request
		      end
	      else
	      	error = "Wrong file format" if error == false
	      	http = :bad_request
	      end
			rescue
		  	error = true
      	http = :bad_request
			end
  		render :json => { error: error, album: a.as_json(:include => { musics: {}, genres: {}, descriptions: {} } ) }, :status => http
  	end

  	# To parse the descriptions and know if one at least is english
		def parseDescriptions(descriptions, error)
			tmpDesc = []
			alreadyIn = []

			descriptions.each { |x|
				if (!alreadyIn.include? x["language"])
					obj = Language.find_by_abbreviation(x["language"])
					if (obj != nil)
						tmpDesc << x
						alreadyIn << x["language"]
					end
				end
			}
			if (!alreadyIn.include? 'EN')
				error = true
			end
			return tmpDesc
		end

		# To get the info about the proposed albums
		def getPropose
    	if (@u == nil || (@u != nil && !@u.isArtist?))
    		codeAnswer 500
    		defineHttp :forbidden
    		sendJson and return
    	end

  		albums = @u.albums
  		albumInPacks = []
  		albums.each do |album|
  			if album.packs.size > 0
  				albumInPacks << { album: album, pack: album.packs }
  			end

  			proposed = Proposition.where(artist_id: @u.id).where(album_id: album.id).all
  			album.setProposed proposed.size == 1
  		end
  		render :json => { albumInPacks: albumInPacks, albums: albums.as_json(:methods => :getProposed, :include => { musics: {}, genres: {}, descriptions: {} } ) }
		end

		# Delete or create a proposition
		def proposeAlbums
    	if (@u == nil || (@u != nil && !@u.isArtist?))
    		codeAnswer 500
    		defineHttp :forbidden
    		sendJson and return
    	end

			if (params.has_key?(:arr_id) && params[:arr_id].is_a?(Array))
				params[:arr_id].each do |id|
					proposed = Proposition.where(artist_id: @u.id).where(album_id: id).all
					if (proposed.size == 1)
						proposed.first.destroy
					else
						p = Proposition.new
						p.artist_id = @u.id
						p.album_id = id
						p.state = 0
						p.date_posted = Date.new
						p.save
					end
				end
			end
			render :json => {}
		end

		# Upload a rediffusion for the software and put it in an album
    # 
    # Route : /musics/uploadRediff
    #
    # ==== Options for the upload
    # 
    # * +filename+ - The filename of the music
    # * +data+ - A piece of string
    #
    # ==== Options for the finish (last call after the upload)
    # 
    # * +finish+ - The value doesn't matter, put 1
    # * +album_id+ - The id of the album where we put the music
    # * +music_name+ - The name of the music
    # * +duration+ - The duration of the music
    # * +price+ - The price of the music
    # * +filename+ - The name of the music file (same as before) uploaded
    # * +limited+ - 0 or 1 to know if the music can be fully listen or not
		def uploadRediff
			begin
				if (@u == nil || (@u != nil && !@u.isArtist?))
	    		codeAnswer 500
	    		defineHttp :forbidden
	    		sendJson and return
	    	end

	    	if (params.has_key?(:finish) && params.has_key?(:album_id) && params.has_key?(:music_name) && params.has_key?(:duration) &&
	    			params.has_key?(:price) && params.has_key?(:filename) && params.has_key?(:limited))
	    		a = Album.find_by_id(params[:album_id])

	    		m = Music.new
	    		m.user_id = @u.id
	    		m.album_id = a.id
	    		m.title = params[:music_name]
	    		m.duration = params[:duration]
	    		m.price = params[:price]
	    		m.file = params[:filename].gsub(/[^0-9A-Za-z\.-]/, '')
	    		m.limited = params[:limited]
	    		m.save

	    		d = Description.new
					d.description = "This is a rediffusion"
					d.language = "EN"
					if (d.save)
						a.descriptions << d
					end

					contentFile = File.open(Rails.root.join('app', 'assets', 'musics', @u.id.to_s, m.file + '.mp3'), 'rb').read
          File.open(Rails.root.join('app', 'assets', 'musics', @u.id.to_s, "cut_#{m.file}.mp3"), 'wb').write(contentFile)
	    	elsif (params.has_key?(:filename) && params.has_key?(:data))
	    		n = 0
	    		data = Base64.decode64 params[:data]

	    		File.open(Rails.root.join('app', 'assets', 'musics', @u.id.to_s, params[:filename].gsub(/[^0-9A-Za-z\.-]/, '') + '.mp3'), 'ab') do |f|
	          n = f.write(data)
	        end

	        @returnValue[:content] = { char_written: n }
	      else
	    		codeAnswer 500
	    		defineHttp :bad_request
	    	end
    	rescue
	    	codeAnswer 504
    		defineHttp :service_unavailable
	    end
   		sendJson
		end

		# Create an album for the software. There is a default image, it can be modified by the website
    # 
    # Route : /musics/createAlbumSoftware
    #
    # ==== Options
    # 
    # * +album_name+ - The name of the album
    # * +price+ - The price of the album
    # * +yearProd+ - The year of the production
		def createAlbum
			begin
				if (@u == nil || (@u != nil && !@u.isArtist?))
	    		codeAnswer 500
	    		defineHttp :forbidden
	    		sendJson and return
	    	end

	    	if (params.has_key?(:album_name) && params.has_key?(:price) && params.has_key?(:yearProd))
	    		a = Album.new
	    		a.user_id = @u.id
	    		a.title = params[:album_name]
	    		a.image = "default.jpg"
	    		a.price = params[:price]
	    		a.file = "default.jpg"
	    		a.yearProd = params[:yearProd]
	    		a.save!
	        @returnValue[:content] = a.as_json(:only => Album.miniKey)
	      else
	    		codeAnswer 500
	    		defineHttp :bad_request
	    	end
	    rescue
	    	codeAnswer 504
    		defineHttp :service_unavailable
	    end
   		sendJson
		end
	end
end