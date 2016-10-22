ActiveAdmin.register Address do

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

	permit_params :numberStreet, :complement, :street, :city, :country, :zipcode

form do |f|
  f.semantic_errors # shows errors on :base

  f.inputs do
  	f.input :numberStreet
		f.input :complement
		f.input :street
		f.input :city
		f.input :country, as: :string
		f.input :zipcode
	end

  f.actions         # adds the 'Submit' and 'Cancel' buttons
end


end
