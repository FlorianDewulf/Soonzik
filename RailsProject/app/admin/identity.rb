ActiveAdmin.register Identity do

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

	permit_params :user_id, :provider, :uid

	controller do
    def create
      @identity = Identity.new(permitted_params[:identity])

      if @identity.save
        redirect_to admin_identity_path(@identity)
      else
      	render :new
      end
    end

    def new
    	@identity = Identity.new
    end

    def edit
    	@identity = Identity.eager_load(:user).find_by_id(params[:id])
    end

    def update
    	@identity = Identity.eager_load(:user).find_by_id(params[:id])

    	@identity.update(permitted_params[:identity])

      if @identity.save
        redirect_to admin_identity_path(@identity)
      else
      	render :edit
      end
    end
  end

  form do |f|
	  f.semantic_errors # shows errors on :base
	  #f.inputs

	  f.inputs do
			f.input :provider
			f.input :uid
			f.input :user
		end

	  f.actions         # adds the 'Submit' and 'Cancel' buttons
	end

end
