ActiveAdmin.register Meet do

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

	permit_params :user_id, :location, :query, :profession, :what, :fromDate, :toDate, :email

	form do |f|
	  f.semantic_errors # shows errors on :base
	  #f.inputs

	  f.inputs do
		  f.input :location
		  f.input :query
		  f.input :profession
		  f.input :what
		  f.input :fromDate, :as => :datetime_select
		  f.input :toDate, :as => :datetime_select
		  f.input :email
		  f.input :user
		end

	  f.actions         # adds the 'Submit' and 'Cancel' buttons
	end

end
