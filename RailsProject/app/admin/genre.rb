ActiveAdmin.register Genre do

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
	remove_filter :genres_influences
	remove_filter :genres_albums
	remove_filter :genres_musics

	permit_params :style_name, :color_name, :color_hexa

	controller do
    def create
      @genre = Genre.new(permitted_params[:genre])

      if @genre.save
        @genre.influences << Influence.where(id: params[:genre][:influence_ids])
        @genre.albums << Album.where(id: params[:genre][:album_ids])
        @genre.musics << Music.where(id: params[:genre][:music_ids])
        redirect_to admin_genre_path(@genre)
      else
      	render :new
      end
    end

    def new
    	@genre = Genre.new
    end

    def edit
    	@genre = Genre.eager_load(:influences, :albums, :musics).find_by_id(params[:id])
    	@genre.influence_ids = @genre.influences.ids
    	@genre.album_ids = @genre.albums.ids
    	@genre.music_ids = @genre.musics.ids
    end

    def update
    	@genre = Genre.eager_load(:influences, :albums, :musics).find_by_id(params[:id])

    	@genre.update(permitted_params[:genre])

      if @genre.save
        @genre.influences.clear
        @genre.albums.clear
        @genre.musics.clear
        @genre.influences << Influence.where(id: params[:genre][:influence_ids])
        @genre.albums << Album.where(id: params[:genre][:album_ids])
        @genre.musics << Music.where(id: params[:genre][:music_ids])
        redirect_to admin_genre_path(@genre)
      else
      	render :edit
      end
    end
  end

	form do |f|
	  f.semantic_errors # shows errors on :base
	  #f.inputs

	  f.inputs do
			f.input :style_name
			f.input :color_name
			f.input :color_hexa
	  	f.input :influences, :as => :check_boxes, collection: f.object.generateSelectedInfluenceCollection
	  	f.input :albums, :as => :check_boxes, collection: f.object.generateSelectedAlbumCollection
	  	f.input :musics, :as => :check_boxes, collection: f.object.generateSelectedMusicCollection
		end

	  f.actions         # adds the 'Submit' and 'Cancel' buttons
	end

end
