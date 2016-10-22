ActiveAdmin.register Description do

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

	permit_params :description, :language

	controller do
    def create
      @description = Description.new(permitted_params[:description])

      if @description.save
        @description.packs << Pack.where(id: params[:description][:pack_ids])
        @description.albums << Album.where(id: params[:description][:album_ids])

        redirect_to admin_description_path(@description)
      else
      	render :new
      end
    end

    def new
    	@description = Description.new
    end

    def edit
    	@description = Description.eager_load(:albums, :pack).find_by_id(params[:id])
    	@description.pack_ids = @description.packs.ids
    	@description.album_ids = @description.albums.ids
    end

    def update
    	@description = Description.eager_load(:albums, :packs).find_by_id(params[:id])

    	@description.update(permitted_params[:description])

      if @description.save
      	@description.packs.clear
      	@description.albums.clear
        @description.packs << Pack.where(id: params[:description][:pack_ids])
        @description.albums << Album.where(id: params[:description][:album_ids])

        redirect_to admin_description_path(@description)
      else
      	render :edit
      end
    end
  end

	form do |f|
	  f.semantic_errors # shows errors on :base
	  #f.inputs

	  f.inputs do
			f.input :description, :as => :text
			f.input :language, :as => :select, collection: Language.pluck(:abbreviation)
	  	f.input :packs, :as => :check_boxes, collection: f.object.generateSelectedPackCollection
	  	f.input :albums, :as => :check_boxes, collection: f.object.generateSelectedAlbumCollection
		end

	  f.actions         # adds the 'Submit' and 'Cancel' buttons
	end

	remove_filter :descriptions_albums
	remove_filter :descriptions_packs

end
