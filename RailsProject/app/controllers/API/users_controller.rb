module API
	# Controller which manage the transaction for the Users objects
	# Here is the list of action available :
	#
	# * index			  [get]
	# * artists		  [get]
	# * show				[get]
	# * find				[get]
	# * save				[post]
	# * update			[post] - SECURE
	# * getmusics	 [get] - SECURE
	# * isartist		[get]
	# * follow			[post] - SECURE
	# * unfollow		[post] - SECURE
	# * addfriend	 [post] - SECURE
	# * delfriend	 [post] - SECURE
	# * getFriends	[get]
	# * getFollows	[get]
	# * getFollowers [get]
	# * uploadImg	 [post] - SECURE
	# * linkSocial	[post] - SECURE
	# * getIdentities	[get] - SECURE
	#
	class UsersController < ApisecurityController
		# Retrieve all the users
		#
		# Route : /users
		#
		# ==== Options
		# 
		# * +count+ - (optionnal) Get the number of object and not the object themselve. Useful for pagination. Set it to "true".
		#
		# ===== HTTP VALUE
		# 
		# - +200+ - In case of success, return a list of users
		# - +503+ - Error from server
		# 
		def index
			begin
				if (@count.present? && @count == "true")
					@returnValue = { content: User.count }
				else
					@returnValue = { content: User.eager_load(:groups).all.as_json(:only => User.miniKey, :include => { groups: { only: [:name] } } ) }
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

		# Retrieve all the artists
		#
		# Route : /users/artists
		#
		# ==== Options
		# 
		# * +count+ - (optionnal) Get the number of object and not the object themselve. Useful for pagination. Set it to "true".
		# * +offset+ - (optionnal) The offset, default value : 0
		# * +limit+ - (optionnal) The number of user you want, default value : 30
		#
		# ===== HTTP VALUE
		# 
		# - +200+ - In case of success, return a list of users
		# - +503+ - Error from server
		# 
		def artists
			offset = 0
			limit = 30

			begin
				if (@count.present? && @count == "true")
					@returnValue = { content: User.count }
				else
					offset = @offset.to_i if @offset.present?
					limit = @limit.to_i if @limit.present?
 					u = User.includes(:groups).where(groups: { name: "Artist" }).offset(offset).limit(limit)
					@returnValue = { content: u.as_json(:only => User.miniKey) }
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
		# Route : /users/:id
		#
		# ==== Options
		# 
		# * +id+ - The id of the specific user
		# 
		# ===== HTTP VALUE
		# 
		# - +200+ - In case of success, return an user
		# - +404+ - Can't find the user, the id is probably wrong
		# - +503+ - Error from server
		# 
		def show
			begin
				if (@id =~ /\A[-+]?\d*\.?\d+\z/)
					user = User.eager_load(:groups).find_by_id(@id)
				else
					user = User.eager_load(:groups).find_by_username(@id)
				end
				if (!user)
					codeAnswer 502
					defineHttp :not_found
				else
					@returnValue = { content: user.as_json(:only => User.bigKey, :include => { groups: { only: [:name] } } ) }
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
		# Route : /users/find
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
		#		 http://api.soonzik.com/users/find?attribute[address_id]=1&order_by_desc[]=id&group_by[]=username
		#		 Note : By default, if you precise no attribute, it will take every row
		#
		# ===== HTTP VALUE
		# 
		# - +200+ - In case of success, return a list of users
		# - +503+ - Error from server
		# 
		def find
			begin
				user_object = nil
				if (defined?@attribute)
					# - - - - - - - -
					@attribute.each do |x, y|
						condition = ""
						if (y[0] == "%" && y[-1] == "%")	#LIKE
							condition = ["'users'.? LIKE ?", %Q[#{x}], "%#{y[1...-1]}%"];
						else															#WHERE
							condition = {x => y};
						end

						if (user_object == nil)					#user_object doesn't exist
							user_object = User.eager_load(:groups).where(condition)
						else															#user_object exists
							user_object = user_object.where(condition)
						end
					end
					# - - - - - - - -
				else
					user_object = User.eager_load(:groups).all						#no attribute specified
				end

				order_asc = ""
				order_desc = ""
				# filter the order by asc to create the string
				if (defined?@order_by_asc)
					@order_by_asc.each do |x|
						order_asc += ", " if order_asc.size != 0
						order_asc += ("'users'." + %Q[#{x}] + " ASC")
					end
				end
				# filter the order by desc to create the string
				if (defined?@order_by_desc)
					@order_by_desc.each do |x|
						order_desc += ", " if order_desc.size != 0
						order_desc += ("'users'." + %Q[#{x}] + " DESC")
					end
				end

				if (order_asc.size > 0 && order_desc.size > 0)
					user_object = user_object.order(order_asc + ", " + order_desc)
				elsif (order_asc.size == 0 && order_desc.size > 0)
					user_object = user_object.order(order_desc)
				elsif (order_asc.size > 0 && order_desc.size == 0)
					user_object = user_object.order(order_asc)
				end

				if (defined?@group_by)		#group
					group = []
					@group_by.each do |x|
						group << %Q[#{x}]
					end
					user_object = user_object.group(group.join(", "))
				end

				if (defined?@limit)			 #limit
					user_object = user_object.limit(@limit.to_i)
				end
				if (defined?@offset)			#offset
					user_object = user_object.offset(@offset.to_i)
				end

				@returnValue = { content: user_object.as_json(:only => User.miniKey, :include => { groups: { only: [:name] } } ) }

				if (user_object.size == 0)
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

		# To get all the musics buy by the user
		#
		# Route : /users/getmusics
		#
		# ===== HTTP VALUE
		# 
		# - +200+ - In case of success, return an hash like this : { musics: [], albums: [], packs: [] }
		# - +401+ - It is not a secured transaction
		# - +503+ - Error from server
		# 
		def getmusics
			begin
				if (@security)
					user = User.find_by_id(@user_id)
					contentReturn = { musics: [], albums: [], packs: []}

					contentReturn[:musics] = Music.eager_load([:album, :user]).joins(:purchased_musics => { :purchase => {} }).where(purchased_musics: { purchased_album: nil }).where(purchases: { user_id: user.id }).as_json(only: Music.miniKey, :include => { album: { only: Album.miniKey }, user: { only: User.miniKey } })
					contentReturn[:albums] = Album.eager_load([:musics, :user]).joins(:purchased_albums => { :purchased_musics => { :purchase => {} } }).where(purchased_albums: { purchased_pack: nil }).where(purchases: { user_id: user.id }).as_json(only: Album.miniKey, :include => { musics: { only: Music.miniKey }, user: { only: User.miniKey } })
					contentReturn[:packs] = Pack.eager_load(albums: { user: {}, musics: {} }).joins(:purchased_packs => { :purchased_albums => { :purchased_musics => { :purchase => {} } } }).where(purchases: { user_id: user.id }, purchased_packs: { gift_user_id: @user_id }).as_json(only: Pack.miniKey, :include => { albums: { only: Album.miniKey, :include => { musics: { only: Music.miniKey }, user: { only: User.miniKey } } } })

					@returnValue = { content: contentReturn }
					codeAnswer 200
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

		# Save a new object User. For more information on the parameters, check at the model
		# 
		# Route : /users/save
		#
		# ==== Options
		# 
		# * +user [email]+ - Email of the user
		# * +user [password]+ - Password of the user, not hashed
		# * +user [username]+ - Unique username of the user
		# * +user [birthday]+ - Birthday day with the format : "YYYY-MM-JJ HH:II:SS" you can add '+HH:II' for the GTM
		# * +user [language]+ - Tiny string for the language. Need to be in our language list.
		# * +user [fname]+ - Firstname of the user
		# * +user [lname]+ - Lastname of the user
		# * +user [description]+ - (optionnal) Description of the user
		# * +user [phoneNumber]+ - (optionnal) Phone number of the user. Need to be with the format '+code phonenumber'
		# * +user [facebook]+ - (optionnal) The facebook name after "https://www.facebook.com/" when you are in your profile
		# * +user [twitter]+ - (optionnal) The twitter name after "https://www.twitter.com/" when you are in your profile
		# * +user [googlePlus]+ - (optionnal) The G+ name after "https://plus.google.com/" when you are in your profile
		# * +address [numberStreet]+ - (optionnal if you don't provide anything in the address variable) Number of the street
		# * +address [complement]+ - (optionnal) Other informations if needed
		# * +address [street]+ - (optionnal if you don't provide anything in the address variable) The street name
		# * +address [city]+ - (optionnal if you don't provide anything in the address variable) The city name
		# * +address [country]+ - (optionnal if you don't provide anything in the address variable) The country name
		# * +address [zipcode]+ - (optionnal if you don't provide anything in the address variable) The Zipcode
		# 
		# ===== HTTP VALUE
		# 
		# - +201+ - In case of success, return the new user including its address, friends and follow.
		# - +503+ - Error from server
		# 
		def save
			_save(true, params)
			sendJson
		end

		# Update a specific object User. For more information on the parameters, check at the model.
		# You need to provide one of this following informations.
		# If the user has no address, you need to provide everything (expect 'complement' which is optionnal)
		# If the user has an address, just provide what you want to update
		# 
		# Route : /users/update
		#
		# ==== Options
		# 
		# * +user [email]+ - Email of the user
		# * +user [password]+ - Password of the user, not hashed
		# * +user [username]+ - Unique username of the user
		# * +user [birthday]+ - Birthday day with the format : "YYYY-MM-JJ HH:II:SS" you can add '+HH:II' for the GTM
		# * +user [language]+ - Tiny string for the language. Need to be in our language list.
		# * +user [fname]+ - Firstname of the user
		# * +user [lname]+ - Lastname of the user
		# * +user [description]+ - Description of the user
		# * +user [phoneNumber]+ - Phone number of the user. Need to be with the format '+code phonenumber'
		# * +user [facebook]+ - The facebook name after "https://www.facebook.com/" when you are in your profile
		# * +user [twitter]+ - The twitter name after "https://www.twitter.com/" when you are in your profile
		# * +user [googlePlus]+ - The G+ name after "https://plus.google.com/" when you are in your profile
		# * +address [numberStreet]+ - Number of the street
		# * +address [complement]+ - Other informations if needed
		# * +address [street]+ - The street name
		# * +address [city]+ - The city name
		# * +address [country]+ - The country name
		# * +address [zipcode]+ - The Zipcode
		# 
		# ===== HTTP VALUE
		# 
		# - +201+ - In case of success, return the new user including its address, friends and follow.
		# - +401+ - It is not a secured transaction
		# - +404+ - Can't find the user, the id is probably wrong
		# - +503+ - Error from server
		# 
		def update
			begin
				if (@security)
					user = User.eager_load(:address).find_by_id(@user_id)
					if user == nil
						codeAnswer 502
						defineHttp :not_found
						return
					else
						_save(false, params)
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

		# To know if the user is an artist, to be use for profile
		#
		# Route : /users/:id/isartist
		#
		# ===== HTTP VALUE
		# 
		# - +200+ - In case of success, return an hash with the key "artist" to know if it is one or not, and if yes, return its albums with the musics inside + the top 5 of the musics of this artist
		# - +404+ - The user doesn't exist
		# - +503+ - Error from server
		# 
		def isArtist
			begin
				u = User.eager_load(:albums => { musics: {} }).find_by_id(@id)

				if (!u)
					codeAnswer 502
					defineHttp :not_found
				else
					hash = { artist: u.isArtist? }
					if hash[:artist]
						hash[:albums] = JSON.parse(u.albums.to_json(:only => Album.miniKey, :include => {
																								musics: { only: Music.miniKey }
																							} ))
						topFive = u.giveTopFive
						hash[:topFive] = []
						topFive.each { |music|
							hash[:topFive] << JSON.parse(music[:object].to_json(only: Music.miniKey, :include => {
									album: { only: Album.miniKey }
								}, methods: :getAverageNote))
						}
					end
					@returnValue = { content: hash }
					codeAnswer 200
				end
			rescue
				codeAnswer 504
				defineHttp :service_unavailable
			end
			sendJson
		end

		# To follow someone
		#
		# Route : /users/follow
		#
		# ==== Options
		# 
		# * +follow_id+ - id of the user you want to follow
		#
		# ===== HTTP VALUE
		# 
		# - +200+ - In case of success
		# - +401+ - It is not a secured transaction
		# - +404+ - The user doesn't exist
		# - +405+ - You already follow this user
		# - +503+ - Error from server
		# 
		def follow
			begin
				if (@security)
					u = User.eager_load(:follows).find_by_id(@user_id)
					toFollow = User.find_by_id(@follow_id)

					if (!u || !toFollow)
						codeAnswer 502
						defineHttp :not_found
					else
						code = 201
						http = :created
						u.follows.each { |follow|
							if follow == toFollow
								code = 405
								http = :method_not_allowed
							end
						}
						if code == 201
							u.follows << toFollow
							begin
                n = Notification.new
                n.user_id = toFollow.id
                n.notif_type = "follow"
                n.from_user_id = @user_id
                n.read = false
                n.link = "/users/#{@user_id}"
                n.save
              rescue
              end
							codeAnswer 201
						else
							codeAnswer 503
						end
						codeAnswer code
						defineHttp http
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

		# To unfollow someone
		#
		# Route : /users/unfollow
		#
		# ==== Options
		# 
		# * +follow_id+ - id of the user you want to follow
		#
		# ===== HTTP VALUE
		# 
		# - +200+ - In case of success
		# - +401+ - It is not a secured transaction
		# - +404+ - The user doesn't exist
		# - +405+ - You don't follow this user
		# - +503+ - Error from server
		# 
		def unfollow
			begin
				if (@security)
					u = User.find_by_id(@user_id)
					toFollow = User.find_by_id(@follow_id)

					if (!u || !toFollow)
						codeAnswer 502
						defineHttp :not_found
					else
						code = 405
						http = :method_not_allowed
						u.follows.each { |follow|
							if follow == toFollow
								code = 200
								http = :ok
							end
						}
						if code == 200
							u.follows.delete(toFollow)
							codeAnswer 200
						else
							codeAnswer 502
						end
						codeAnswer code
						defineHttp http
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

		# To add a friend
		#
		# Route : /users/addfriend
		#
		# ==== Options
		# 
		# * +friend_id+ - id of the user you want to add to your friendlist
		#
		# ===== HTTP VALUE
		# 
		# - +200+ - In case of success
		# - +401+ - It is not a secured transaction
		# - +404+ - The user doesn't exist
		# - +405+ - You already have this user in your friendlist
		# - +503+ - Error from server
		# 
		def addfriend
			begin
				if (@security)
					u = User.eager_load(:friends).find_by_id(@user_id)
					friend = User.find_by_id(@friend_id)

					if (!u || !friend)
						codeAnswer 502
						defineHttp :not_found
					else
						code = 201
						http = :created
						u.friends.each { |friendInList|
							if friendInList == friend
								code = 405
								http = :method_not_allowed
							end
						}
						if code == 201
							u.friends << friend
							friend.friends << u
							begin
                n = Notification.new
                n.user_id = friend.id
                n.notif_type = "friend"
                n.from_user_id = @user_id
                n.read = false
                n.link = "/users/#{@user_id}"
                n.save
              rescue
              end
							codeAnswer 201
						else
							codeAnswer 502
						end
						codeAnswer code
						defineHttp http
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

		# To delete a friend
		#
		# Route : /users/delfriend
		#
		# ==== Options
		# 
		# * +friend_id+ - id of the user you want to delete of your friendlist
		#
		# ===== HTTP VALUE
		# 
		# - +200+ - In case of success
		# - +401+ - It is not a secured transaction
		# - +404+ - The user doesn't exist
		# - +405+ - You don't have this user in your friendlist
		# - +503+ - Error from server
		# 
		def delfriend
			begin
				if (@security)
					u = User.find_by_id(@user_id)
					friend = User.find_by_id(@friend_id)

					if (!u || !friend)
						codeAnswer 502
						defineHttp :not_found
					else
						code = 405
						http = :method_not_allowed
						u.friends.each { |friendInList|
							if friendInList == friend
								code = 200
								http = :ok
							end
						}
						if code == 200
							u.friends.delete(friend)
							friend.friends.delete(u)
							codeAnswer 200
						else
							codeAnswer 502
						end
						codeAnswer code
						defineHttp http
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

		# To get the friends of an user
		#
		# Route : /users/:id/friends
		#
		# ==== Options
		# 
		# * +id+ - id of the user you want to get the friendlist
		#
		# ===== HTTP VALUE
		# 
		# - +200+ - In case of success, return an array of users
		# - +404+ - The user doesn't exist
		# - +503+ - Error from server
		# 
		def getFriends
			begin
				u = User.eager_load(:friends).find_by_id(@id)

				if (!u)
					codeAnswer 502
					defineHttp :not_found
				else
					@returnValue = { content: u.friends.reverse_order.as_json(:only => User.miniKey) }
					codeAnswer 200
				end
			rescue
				codeAnswer 504
				defineHttp :service_unavailable
			end
			sendJson
		end

		# To get the follows of an user
		#
		# Route : /users/:id/follows
		#
		# ==== Options
		# 
		# * +id+ - id of the user you want to get the follows
		#
		# ===== HTTP VALUE
		# 
		# - +200+ - In case of success, return an array of users
		# - +404+ - The user doesn't exist
		# - +503+ - Error from server
		# 
		def getFollows
			begin
				u = User.eager_load(:follows).find_by_id(@id)

				if (!u)
					codeAnswer 502
					defineHttp :not_found
				else
					@returnValue = { content: u.follows.reverse_order.as_json(:only => User.miniKey) }
					codeAnswer 200
				end
			rescue
				codeAnswer 504
				defineHttp :service_unavailable
			end
			sendJson
		end

		# To get the followers of an user
		#
		# Route : /users/:id/followers
		#
		# ==== Options
		# 
		# * +id+ - id of the user you want to get the followers
		#
		# ===== HTTP VALUE
		# 
		# - +200+ - In case of success, return an array of users
		# - +404+ - The user doesn't exist
		# - +503+ - Error from server
		# 
		def getFollowers
			begin
				u = User.eager_load(:followers).find_by_id(@id)

				if (!u)
					codeAnswer 502
					defineHttp :not_found
				else
					@returnValue = { content: u.followers.reverse_order.as_json(:only => User.miniKey) }
					codeAnswer 200
				end
			rescue
				codeAnswer 504
				defineHttp :service_unavailable
			end
			sendJson
		end

		# To upload an image or a background
		# Return the new user (to get the new image name)
		#
		# Route : /users/upload
		#
		# ==== Options
		#
		# * +type+ - The type of image you upload : The avatar ('image') or a cover ('background'). It is optionnal, the default value is 'image'
		# * +file [content_type]+ - The content type of the file. Authorized content type : "image/gif", "image/jpeg", "image/pjpeg", "image/png", "image/x-png"
		# * +file [original_filename]+ - The name of the file
		# * +file [tempfile]+ - The data of the file
		# * +device+ - TO SPECIFY FOR SMARTPHONE. It needs to be the key type with the value 'smartphone' or it will be considering you're from website.
		#
		# ==== HTTP VALUE
		#
		# - +200+ - In case of success (content is empty)
		# - +400+ - If the content type is not good (only jpeg, gif and png are authorized)
		# - +401+ - It is not a secured transaction
		# - +503+ - Error from server
		#
		def uploadImg
			smart = false

			begin
				if (@security)
					acceptedContentType = [
						"image/gif",
						"image/jpeg",
						"image/pjpeg",
						"image/png",
						"image/x-png"
					]

					if (@device.present? && @device == 'smartphone')
						smart = true
					else
						@file = { tempfile: @file.tempfile, content_type: @file.content_type, original_filename: @file.original_filename }
					end

					if acceptedContentType.include? @file[:content_type]
						randomNumber = rand(1000..10000)
						timestamp = Time.now.to_i
						folder = ActionController::Base.helpers.asset_path("usersImage/avatars") if (@type != "background")
						folder = ActionController::Base.helpers.asset_path("usersImage/backgrounds") if (@type == "background")
						
						newFilename = Digest::SHA256.hexdigest("#{timestamp}--#{@file[:original_filename]}#{randomNumber}") + "-" + @file[:original_filename].gsub(/[^0-9A-Za-z\.-]/, '')

						File.open(Rails.root.join('app', 'assets', 'images', 'usersImage', ((@type != "background") ? 'avatars' : 'backgrounds'), newFilename), 'wb') do |f|
							f.write(@file[:tempfile].read) if smart == false
							f.write(@file[:tempfile]) if smart == true
						end

						u = User.find_by_id(@user_id)
						u.image = newFilename if (@type != "background")
						u.background = newFilename if (@type == "background")
						u.save!
						@returnValue = { content: u.as_json(only: User.miniKey) }
						codeAnswer 201
					else
						codeAnswer 505
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

		# To link an account with a social network
		#
		# Route : /users/linkSocial
		#
		# ==== Options
		#
		# * +provider+ - Name of the social network : "facebook" | "twitter" | "google"
    # * +uid+ - Id from the social network
		#
		# ==== HTTP VALUE
		#
		# - +200+ - In case of success (content is empty)
		# - +400+ - If the parameters are not good / the access_token is not available
    # - +401+ - It is not a secured transaction
		# - +409+ - Http code for conflict, can't save the identity (uid already taken)
		# - +503+ - Error from server
		#
		def linkSocial
			begin
				if (@security)
          if (@provider.present? && ["facebook", "twitter", "google"].include?(@provider) && @uid.present?)
            id = Identity.new
            id.user_id = @user_id
            id.uid = @uid
            id.provider = @provider
            id.newToken()
            if (id.save)
              codeAnswer 201
            else
              codeAnswer 504
              defineHttp :conflict
            end
          else
            codeAnswer 505
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

		# To get the differents identities of an user
		# 
		# Route : /users/linkSocial
		#
		# ==== Options
		#
		# * +provider+ - Name of the social network : "facebook" | "twitter" | "google"
    # * +uid+ - Id from the social network
		#
		# ==== HTTP VALUE
		#
		# - +200+ - In case of success, return the different identities of an user
    # - +401+ - It is not a secured transaction
		# - +503+ - Error from server
		#
	  def getIdentities
	  	begin
				if (@security)
					u = User.find_by_id(@user_id)
					@returnValue = { content: u.identities.as_json(except: [:created_at, :updated_at]) }
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

		private
		# Common code for save/update (private method)
		# 
		# ==== Attributes
		# 
		# * +save+ - A boolean. True = save, False = update
		# * +params+ - The params in an hash {user: @user, address: @address}
		# 
		def _save(save, params)
			begin
				user = nil
				if (@security && save == false)
					user = User.eager_load(:address).find_by_id(@user_id)
					update_user = false
					update_address = true
					if (params.has_key?(:user))
						update_user = user.update(User.user_params params)
					else
						update_user = true
					end

					if params.has_key?(:address)
						if user.address != nil
							update_address = user.address.update(Address.address_params params)
						else
							address = Address.new(Address.address_params params)
							update_address = address.save
							if (update_address)
								user.address_id = address.id
								user.save
							end
						end
					end

					if ((update_user && update_address))
						@returnValue = { content: user.as_json(:include => {
																																	:address => { :only => Address.miniKey }
																																},
																										:only => User.bigKey) }
						codeAnswer 201
						defineHttp :created
					else
						@returnValue = { content: { user: JSON.parse(user.errors.to_hash.to_json), address: JSON.parse(user.address.errors.to_hash.to_json) } } if user.address != nil
						@returnValue = { content: { user: JSON.parse(user.errors.to_hash.to_json), address: {} } } if user.address == nil
						codeAnswer 505
						defineHttp :service_unavailable
					end
					return
				else
					user = User.new(User.user_params params)
				end

				address = true
				address = Address.new(Address.address_params params) if params.has_key?(:address)
				if (address == true || (address != true && address.save))
					user.address_id = address.id if address != true
					user.skip_confirmation!
					if (user.save)
						@returnValue = { content: user.as_json(:include => {
																																	:address => { :only => Address.miniKey }
																																},
																										:only => User.bigKey) }
						codeAnswer 201
						defineHttp :created
					else
						@returnValue = { content: JSON.parse(user.errors.to_hash.to_json) }
						codeAnswer 503
						defineHttp :service_unavailable
					end
				else
					@returnValue = { content: JSON.parse(address.errors.to_hash.to_json) }
					codeAnswer 503
					defineHttp :service_unavailable
				end
			rescue
				codeAnswer 504
				defineHttp :service_unavailable
			end
		end
	end
end