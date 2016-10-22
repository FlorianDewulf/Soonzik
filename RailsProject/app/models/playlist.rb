# The model of the object Playlist
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +user_id+ - (integer) - The ID of the user
# - +name+ - (string) - The name of the pack
#
# ==== Associations
#
# - +belongs_to+ - :user
# - +has_many+ - :playlist_objects
# - +has_many+ - :musics
#
class Playlist < ActiveRecord::Base
  belongs_to :user

  has_many :playlist_objects, -> { rank(:row_order) }
  has_many :musics, through: :playlist_objects

  validates :user, :name, presence: true
  validates :name, length: { minimum: 1, maximum: 30 }

  # The strong parameters to save or update object
  def self.playlist_params(parameters)
    parameters.require(:playlist).permit(:user_id, :name)
  end

  # Filter of information for the API
  #
  # Fields returned : [:id, :name]
  def self.miniKey
  	[:id, :name]
  end
end
