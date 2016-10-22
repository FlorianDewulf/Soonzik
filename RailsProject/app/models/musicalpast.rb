# The model of the object Musicalpast
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +title+ - (string) - The name of the music
# - +soundcloud_music_id+ - (integer) - The ID of the music on soundcloud
# - +genre_id+ - (integer) - The ID of the genre
# - +user_id+ - (integer) - The ID of the user
#
# ==== Associations
#
# - +belongs_to+ - :user
# - +belongs_to+ - :genres
#
class Musicalpast < ActiveRecord::Base
  belongs_to :genre
  belongs_to :user

  validates :user, :title, :soundcloud_music_id, :genre, presence: true
  
  # The strong parameters to save or update object
  def self.music_params(parameters)
    parameters.require(:music).permit(:user_id, :title, :soundcloud_music_id, :genre_id)
  end
end
