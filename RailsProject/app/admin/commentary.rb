ActiveAdmin.register Commentary do

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

	permit_params :author_id, :content

	controller do
    def create
      @commentary = Commentary.new(permitted_params[:commentary])

      if @commentary.save
        @commentary.albums << Album.where(id: params[:commentary][:album_ids])
        @commentary.news << News.where(id: params[:commentary][:news_ids])

        redirect_to admin_commentary_path(@commentary)
      else
      	render :new
      end
    end

    def new
    	@commentary = Commentary.new
    end

    def edit
    	@commentary = Commentary.eager_load(:albums, :musics, :news, :user).find_by_id(params[:id])
    	@commentary.album_ids = @commentary.albums.ids
    	@commentary.news_ids = @commentary.news.ids
    end

    def update
    	@commentary = Commentary.eager_load(:albums, :musics, :news, :user).find_by_id(params[:id])

    	@commentary.update(permitted_params[:commentary])

      if @commentary.save
      	@commentary.albums.clear
      	@commentary.news.clear
        @commentary.albums << Album.where(id: params[:commentary][:album_ids])
        @commentary.news << News.where(id: params[:commentary][:news_ids])

        redirect_to admin_commentary_path(@commentary)
      else
      	render :edit
      end
    end
  end

	form do |f|
	  f.semantic_errors # shows errors on :base
	  #f.inputs

	  f.inputs do
			f.input :content, :as => :text
			f.input :user
	  	f.input :news, :as => :check_boxes, collection: f.object.generateSelectedNewsCollection
	    f.input :albums, :as => :check_boxes, collection: f.object.generateSelectedAlbumCollection
		end

	  f.actions         # adds the 'Submit' and 'Cancel' buttons
	end

	remove_filter :commentaries_news
	remove_filter :commentaries_musics
	remove_filter :commentaries_albums

end
