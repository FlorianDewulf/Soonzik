ActiveAdmin.register Battle do

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

	permit_params :date_begin, :date_end, :artist_one_id, :artist_two_id

	form do |f|
	  f.semantic_errors # shows errors on :base
	  #f.inputs

	  f.inputs do
			f.input :date_begin
			f.input :date_end
			f.input :artist_one
			f.input :artist_two
		end

	  f.actions         # adds the 'Submit' and 'Cancel' buttons
	end

end
