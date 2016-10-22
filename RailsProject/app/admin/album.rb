ActiveAdmin.register Album do

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

	permit_params :user_id, :title, :price, :file, :yearProd, :image, music_ids: [:id, :album_id], genre_ids: [:id], pack_ids: [:id]

	controller do
    def create
      @album = Album.new(permitted_params[:album])

      if @album.save
        @album.musics << Music.where(id: params[:album][:music_ids])
        @album.genres << Genre.where(id: params[:album][:genre_ids])
        @album.packs << Pack.where(id: params[:album][:pack_ids])

        redirect_to admin_album_path(@album)
      else
      	render :new
      end
    end

    def new
    	@album = Album.new
    end

    def edit
    	@album = Album.eager_load(:genres, :musics, :packs).find_by_id(params[:id])
    	@album.music_ids = @album.musics.ids
    	@album.genre_ids = @album.genres.ids
    	@album.pack_ids = @album.packs.ids
    end

    def update
    	@album = Album.eager_load(:genres, :musics, :packs).find_by_id(params[:id])

    	@album.update(permitted_params[:album])

      if @album.save
      	@album.musics.clear
      	@album.genres.clear
      	@album.packs.clear
        @album.musics << Music.where(id: params[:album][:music_ids])
        @album.genres << Genre.where(id: params[:album][:genre_ids])
        @album.packs << Pack.where(id: params[:album][:pack_ids])

        redirect_to admin_album_path(@album)
      else
      	render :edit
      end
    end
  end

	form do |f|
	  f.semantic_errors # shows errors on :base
	  #f.inputs

	  f.inputs do
		  f.input :title
		  f.input :price, as: :number
		  f.input :yearProd, as: :number
		  f.input :file
		  f.input :image
	    f.input :user, :as => :select

	  	f.input :musics, :as => :check_boxes, collection: f.object.generateSelectedMusicCollection
	    f.input :genres, :as => :check_boxes, collection: f.object.generateSelectedGenreCollection
	    f.input :packs, :as => :check_boxes, collection: f.object.generateSelectedPackCollection
		end

	  f.actions         # adds the 'Submit' and 'Cancel' buttons
	end

	remove_filter :albums_descriptions
	remove_filter :albums_genres
	remove_filter :albums_packs
	remove_filter :albums_commentaries

end
