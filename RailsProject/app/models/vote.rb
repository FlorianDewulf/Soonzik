# The model of the object Vote
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +user_id+ - (integer) - The ID of the user
# - +artist_id+ - (integer) - The ID of the artist
# - +battle_id+ - (integer) - The ID of the battle
#
# ==== Associations
#
# - +belongs_to+ - :user
# - +belongs_to+ - :battle
# - +belongs_to+ - :artist
#
class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :battle
  belongs_to :artist, class_name: 'User', foreign_key: 'artist_id'

  validates :user, :battle, :artist, presence: true

  # The strong parameters to save or update object
  def self.vote_params(parameters)
    parameters.require(:vote).permit(:user_id, :battle_id, :artist_id)
  end

  # Filter of information for the API
  #
  # Fields returned : [:id, :user_id, :artist_id]
  def self.miniKey
  	[:id, :user_id, :artist_id]
  end
end
