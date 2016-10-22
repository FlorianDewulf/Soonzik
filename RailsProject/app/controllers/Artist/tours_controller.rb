module Artist
  # Controller which manage main page of the artist panel
  #
  class ToursController < ArtistsecurityController
  	before_action :setMenu

  	# For the menu bar
  	def setMenu
  		@menu = 'tour'
  	end

  	# The index page for the tour management
  	def index
  		@concerts = Concert.where(user_id: @current_user.id)
  	end

  	# The edit page for a concert
  	def edit
  		if (params.has_key?(:id))
  			@concert = Concert.find_by_id(params[:id])
  			if @concert == nil || @concert.user_id != current_user.id
  				redirect_to artist_tour_path, notice: 'This concert doesn\'t exist'
  			end
  		else
  			redirect_to artist_tour_path, notice: 'The url is wrong'
  		end
  	end

  	# The update function for the concert
  	def update
  		notice = ''

  		if (params.has_key?(:id))
  			@concert = Concert.find_by_id(params[:id])
  			if @concert == nil || @concert.user_id != current_user.id
  				notice = 'This concert doesn\'t exist'
  			end
  		else
  			notice = 'The url is wrong'
  		end
  		@concert.address.update_attributes(Address.address_params params)
  		@concert.update_attributes(Concert.concert_params params)
  		redirect_to artist_tour_path, notice: notice if notice.size > 0
  		redirect_to artist_tour_path if notice.size == 0
  	end

  	# The delete function for the concert
  	def delete
  		if (params.has_key?(:id))
  			@concert = Concert.find_by_id(params[:id])
  			if @concert == nil || @concert.user_id != current_user.id
  				redirect_to artist_tour_path, notice: 'This concert doesn\'t exist'
  			end
  			@concert.address.delete
  			@concert.delete
  			redirect_to artist_tour_path, notice: 'Successfully deleted'
  		else
  			redirect_to artist_tour_path, notice: 'The url is wrong'
  		end
  	end

  	###############
  	# AJAX ROUTES #
  	###############

  	def create_concert
  		respond_to do |format|
  			format.html { redirect_to artist_root_path }
        format.json {

          if (@u == nil || (@u != nil && !@u.isArtist?))
            codeAnswer 500
            defineHttp :forbidden
            sendJson and return
          end

		  		c = Concert.new(Concert.concert_params params)
		  		a = Address.new(Address.address_params params)

		  		if (a.save)
		  			c.address_id = a.id
		  			c.user_id = @u.id
		  			if (c.save)
		  				render :json => c.as_json(:include => {
	  						address: {}
	  					})
		  			else
		  				a.delete
			  			render :json => { concert: c.errors }, :status => :bad_request
		  			end
		  		else
		  			render :json => { address: a.errors }, :status => :bad_request
		  		end
		  	}
		  end
  	end
  end
end