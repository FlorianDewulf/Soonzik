ActiveAdmin.register Newsletter do

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

	actions :index, :show, :new, :create, :destroy
	permit_params :obj_msg, :html_content

	controller do
    def create
      @newsletter = Newsletter.new(permitted_params[:newsletter])

      if @newsletter.save
      	Thread.new do
				  @newsletter.send_to_all_user
				  ActiveRecord::Base.connection.close
				end
        redirect_to admin_newsletter_path(@newsletter)
      else
      	render :new
      end
    end

    def new
    	@newsletter = Newsletter.new
    end
  end


	form do |f|
	  f.semantic_errors # shows errors on :base
	  #f.inputs

	  f.inputs do
		  f.input :obj_msg, label: 'Object'
		  f.input :html_content, as: :text
		end

	  f.actions         # adds the 'Submit' and 'Cancel' buttons
	end

end
