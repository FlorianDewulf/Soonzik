module Artist
  # Controller which manage meet page of the artist panel
  #
  class MeetsController < ArtistsecurityController
  	before_action :setMenu

  	# For the menu bar
  	def setMenu
  		@menu = 'meet'
  	end

		# The index page for the search engine
  	def index
  		@meet = Meet.new
  		generateSelectOptions(current_user.language)
  	end

  	def save
  		@meet = Meet.new
  		if request.post? && params[:meet]
  			@meet = Meet.new(Meet.meet_params params)
  			@meet.user_id = current_user.id
	      if @meet.save
	        redirect_to artist_meet_path, notice: 'Your meeting query was successfully created.'
	      else
		  		generateSelectOptions(current_user.language)
	        render :action => 'index'
	      end
	    end
  	end

  	def show
  		@meetSearch = Meet.eager_load(:user).where(query: 'search')
  		@meetPropose = Meet.eager_load(:user).where(query: 'propose')
  	end

  	def destroy
  		if params.has_key?(:id)
  			meet = Meet.find_by_id(params[:id])
  			if (meet != nil && meet.user_id == current_user.id)
  				meet.delete
  			end
  		end
  		redirect_to artist_meet_path
  	end

  	private
  		def generateSelectOptions(language)
  			@professionsArray = Meetstring.where(language: language).where(stringtype: 'profession')
	  		@typesArray = Meetstring.where(language: language).where(stringtype: 'type')

	  		@professionsArray = Meetstring.where(language: 'EN').where(stringtype: 'profession') if @professionsArray.length == 0
	  		@typesArray = Meetstring.where(language: 'EN').where(stringtype: 'type') if @typesArray.length == 0
  		end

  end
end