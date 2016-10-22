# The model of the object MusicNote
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +user_id+ - (integer) - The ID of the user
# - +music_id+ - (integer) - The ID of the music
# - +value+ - (integer) - The value of the note
#
# ==== Associations
#
# - +belongs_to+ - :user
# - +belongs_to+ - :music
#
class MusicNote < ActiveRecord::Base
  belongs_to :user
  belongs_to :music

  validates :music, :user, :value, presence: true
  validates :value, numericality: true

  # The strong parameters to save or update object
  def self.music_note_params(parameters)
    parameters.require(:music_note).permit(:user_id, :music_id, :value)
  end
end
