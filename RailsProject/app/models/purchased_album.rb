# The model of the object PurchasedAlbums
# Contain the relation and the validation
# Can provide some features linked to this model
#
# This object will never be used for something else than relation
class PurchasedAlbum < ActiveRecord::Base
	has_many :purchased_musics
	belongs_to :album
	belongs_to :purchased_pack

	def to_s
		return id
	end
end
