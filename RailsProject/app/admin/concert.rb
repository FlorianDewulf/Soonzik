ActiveAdmin.register Concert do

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

	permit_params :planification, :url, :user_id, :address_id

	controller do
    def create
      @concert = Concert.new(permitted_params[:concert])

      if @concert.save
        redirect_to admin_concert_path(@concert)
      else
      	render :new
      end
    end

    def new
    	@concert = Concert.new
    end

    def edit
    	@concert = Concert.eager_load(:address, :user).find_by_id(params[:id])
    end

    def update
    	@concert = Concert.eager_load(:address, :user).find_by_id(params[:id])

    	@concert.update(permitted_params[:concert])

      if @concert.save
        redirect_to admin_concert_path(@concert)
      else
      	render :edit
      end
    end
  end

	form do |f|
	  f.semantic_errors # shows errors on :base
	  #f.inputs

	  f.inputs do
			f.input :url
			f.input :planification, :as => :datetime_select
	  	f.input :user
	  	f.input :address
		end

	  f.actions         # adds the 'Submit' and 'Cancel' buttons
	end

end
