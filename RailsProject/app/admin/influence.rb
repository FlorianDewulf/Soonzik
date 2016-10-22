ActiveAdmin.register Influence do

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

	permit_params :name

	controller do
    def create
      @influence = Influence.new(permitted_params[:influence])

      if @influence.save
        @influence.genres << Genre.where(id: params[:influence][:genre_ids])

        redirect_to admin_influence_path(@influence)
      else
      	render :new
      end
    end

    def new
    	@influence = Influence.new
    end

    def edit
    	@influence = Influence.eager_load(:genres).find_by_id(params[:id])
    	@influence.genre_ids = @influence.genres.ids
    end

    def update
    	@influence = Influence.eager_load(:genres).find_by_id(params[:id])

    	@influence.update(permitted_params[:influence])

      if @influence.save
      	@influence.genres.clear
        @influence.genres << Genre.where(id: params[:influence][:genre_ids])

        redirect_to admin_influence_path(@influence)
      else
      	render :edit
      end
    end
  end

	form do |f|
	  f.semantic_errors # shows errors on :base
	  #f.inputs

	  f.inputs do
		  f.input :name

	    f.input :genres, :as => :check_boxes, collection: f.object.generateSelectedGenreCollection
		end

	  f.actions         # adds the 'Submit' and 'Cancel' buttons
	end

	remove_filter :influences_genres

end
