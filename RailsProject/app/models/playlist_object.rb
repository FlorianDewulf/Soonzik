# The model of the object PlaylistMusic
# Contain the relation and the validation
# Can provide some features linked to this model
#
# This object will never be used for something else than relation and the "row_order" field (to sort playlist)
class PlaylistObject < ActiveRecord::Base
  include RankedModel

	ranks				:row_order,
							:with_same => :playlist_id
	belongs_to	:playlist

	has_and_belongs_to_many		:musics


  accepts_nested_attributes_for :musics, allow_destroy: true
  attr_accessor :music_ids

  # The strong parameters to save or update object
  def self.playlist_params(parameters)
    parameters.require(:playlist_object).permit(:playlist_id, :row_order)
  end

  # for admin panel, to have selected checkbox
  def generateSelectedMusicCollection
    collection = Music.pluck('title, id')
    collection.each do |collect|
      if ((self.music_ids) && self.music_ids.include?(collect[1]))
        collect[2] = { checked: true }
      else
        collect[2] = { checked: false }
      end
    end
    return collection
  end
end
