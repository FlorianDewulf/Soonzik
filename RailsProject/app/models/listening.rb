# The model of the object Listening
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +when+ - (date) - The name of the group (deprecated, need to be remove)
# - +latitude+ - (float) - The latitude of the position
# - +longitude+ - (float) - The longitude of the position
# - +music_id+ - (integer) - The ID of the music listened
# - +user_id+ - (integer) - The ID of the user who listen music
#
# ==== Associations
#
# - +belongs_to+ - :music
# - +belongs_to+ - :user
#
class Listening < ActiveRecord::Base

  acts_as_mappable :default_units => :kms,
                   :default_formula => :sphere,
                   :distance_field_name => :distance,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude


  belongs_to :music
  belongs_to :user

  validates :user, :music, :latitude, :longitude, presence: true
  validates :latitude, :longitude, numericality: true

  # Filter of information for the API - Restricted
  #
  # Fields returned : [:id, :created_at, :latitude, :longitude]
  def self.miniKey
    [:id, :created_at, :latitude, :longitude]
  end

  # To render with the distance to
  def setOrigin(origin)
    @origin = origin
  end

  # To render the distance to in json
  def distance
    self.distance_from(@origin) * 1.609344
  end

  # The strong parameters to save or update object
  def self.listening_params(parameters)
    parameters.require(:listening).permit(:user_id, :music_id, :latitude, :longitude)
  end
end
