ActiveAdmin.register Cart do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end
	remove_filter :carts_albums
	remove_filter :carts_musics

	permit_params :user_id


	controller do
    def create
      @cart = Cart.new(permitted_params[:cart])

      if @cart.save
      	if (params[:cart].has_key?(:music_ids) && params[:cart][:music_ids].size > 1)
	        @cart.musics << Music.where(id: params[:cart][:music_ids])
        elsif (params[:cart].has_key?(:album_ids) && params[:cart][:album_ids].size > 1)
	        @cart.albums << Album.where(id: params[:cart][:album_ids])
        else
        	@cart.delete
	      	render :new
	      	return
        end

        redirect_to admin_cart_path(@cart)
      else
      	render :new
      end
    end

    def new
    	@cart = Cart.new
    end

    def edit
    	@cart = Cart.eager_load(:albums, :musics).find_by_id(params[:id])
    	@cart.music_ids = @cart.musics.ids
    	@cart.album_ids = @cart.albums.ids
    end

    def update
    	@cart = Cart.eager_load(:albums, :musics).find_by_id(params[:id])

    	@cart.update(permitted_params[:cart])

      if @cart.save
      	@cart.musics.clear
      	@cart.albums.clear
      	if (params[:cart].has_key?(:music_ids) && params[:cart][:music_ids].size > 1)
	        @cart.musics << Music.where(id: params[:cart][:music_ids])
        elsif (params[:cart].has_key?(:album_ids) && params[:cart][:album_ids].size > 1)
	        @cart.albums << Album.where(id: params[:cart][:album_ids])
        else
	      	render :edit
	      	return
        end

        redirect_to admin_cart_path(@cart)
      else
      	render :edit
      end
    end
  end

	form do |f|
	  f.semantic_errors # shows errors on :base
	  #f.inputs

	  f.inputs do
			f.input :user
	  	f.input :musics, :as => :check_boxes, collection: f.object.generateSelectedMusicCollection
	    f.input :albums, :as => :check_boxes, collection: f.object.generateSelectedAlbumCollection
		end

	  f.actions         # adds the 'Submit' and 'Cancel' buttons
	end

end
