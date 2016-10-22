ActiveAdmin.register Feedback do

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

	permit_params :user_id, :email, :type_object, :object, :text

	controller do
    def create
      @feedback = Feedback.new(permitted_params[:feedback])

      if @feedback.save
        redirect_to admin_feedback_path(@feedback)
      else
      	render :new
      end
    end

    def new
    	@feedback = Feedback.new
    end

    def edit
    	@feedback = Feedback.eager_load(:user).find_by_id(params[:id])
    end

    def update
    	@feedback = Feedback.eager_load(:user).find_by_id(params[:id])

    	@feedback.update(permitted_params[:feedback])

      if @feedback.save
        redirect_to admin_feedback_path(@feedback)
      else
      	render :edit
      end
    end
  end

	form do |f|
	  f.semantic_errors # shows errors on :base
	  #f.inputs

	  f.inputs do
			f.input :email
			f.input :type_object
			f.input :object
			f.input :text, :as => :text
			f.input :user
		end

	  f.actions         # adds the 'Submit' and 'Cancel' buttons
	end

end
