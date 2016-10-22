# The model of the object Proposition
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +artist_id+ - (integer) - The ID of the artist
# - +album_id+ - (integer) - The ID of the album
# - +state+ - (integer) - Enum to know the state of the proposition
# - +date_posted+ - (date) - The date of the proposition
#
# ==== Associations
#
# - +belongs_to+ - :user
# - +belongs_to+ - :album
#
class Proposition < ActiveRecord::Base
  belongs_to :user, foreign_key: 'artist_id'
  belongs_to :album

  validates :user, :album, :state, presence: true

  # The strong parameters to save or update object
  def self.proposition_params(parameters)
    parameters.require(:proposition).permit(:artist_id, :album_id, :state, :date_posted)
  end
end
