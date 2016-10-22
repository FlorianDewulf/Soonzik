# The model of the object Concertlike
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +album_id+ - (integer) - The ID of the concert liked
# - +user_id+ - (integer) - The ID of the user who liked
#
# ==== Associations
#
# - +belongs_to+ - :concert
#
class Concertslike < ActiveRecord::Base
  belongs_to :concert
end