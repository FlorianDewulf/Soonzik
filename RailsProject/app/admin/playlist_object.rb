ActiveAdmin.register PlaylistObject do

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

	permit_params :playlist_id, :row_order, :music_id

	remove_filter :playlistobjects_musics

	controller do
    def create
      @playlist_object = PlaylistObject.new(permitted_params[:playlist_object])
      if params.has_key?(:playlist_object) && params[:playlist_object].has_key?(:music_ids) && params[:playlist_object][:music_ids].size > 0
	      @playlist_object.music_id = params[:playlist_object][:music_ids][0]
	    end

      if @playlist_object.save
        @playlist_object.musics << Music.where(id: params[:playlist_object][:music_ids])

        redirect_to admin_playlist_object_path(@playlist_object)
      else
      	render :new
      end
    end

    def new
    	@playlist_object = PlaylistObject.new
    end

    def edit
    	@playlist_object = PlaylistObject.eager_load(:musics).find_by_id(params[:id])
    	@playlist_object.music_ids = @playlist_object.musics.ids
    end

    def update
    	@playlist_object = PlaylistObject.eager_load(:musics).find_by_id(params[:id])

      if params.has_key?(:playlist_object) && params[:playlist_object].has_key?(:music_ids) && params[:playlist_object][:music_ids].size > 0
	      @playlist_object.music_id = params[:playlist_object][:music_ids][0]
	    end

    	@playlist_object.update(permitted_params[:playlist_object])

      if @playlist_object.save
      	@playlist_object.musics.clear
        @playlist_object.musics << Music.where(id: params[:playlist_object][:music_ids])

        redirect_to admin_playlist_object_path(@playlist_object)
      else
      	render :edit
      end
    end
  end

	form do |f|
	  f.semantic_errors # shows errors on :base
	  #f.inputs

	  f.inputs do
	    f.input :playlist, :as => :select
	    f.input :row_order
	  	f.input :musics, :as => :radio, collection: f.object.generateSelectedMusicCollection
		end

	  f.actions         # adds the 'Submit' and 'Cancel' buttons
	end

end
