ActiveAdmin.register Listening do

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

	permit_params :latitude, :longitude, :music_id, :user_id

	form do |f|
	  f.semantic_errors # shows errors on :base
	  #f.inputs

	  f.inputs do
		  f.input :latitude, as: :number
		  f.input :longitude, as: :number
		  f.input :music
		  f.input :user
		end

	  f.actions         # adds the 'Submit' and 'Cancel' buttons
	end

end
