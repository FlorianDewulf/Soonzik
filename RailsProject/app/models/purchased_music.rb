# The model of the object PurchasedMusics
# Contain the relation and the validation
# Can provide some features linked to this model
#
# This object will never be used for something else than relation
class PurchasedMusic < ActiveRecord::Base
	belongs_to :purchase
	belongs_to :music
	belongs_to :purchased_album

	def to_s
		return id
	end
end
