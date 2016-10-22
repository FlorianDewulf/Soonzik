# The model of the object Albumlike
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +album_id+ - (integer) - The ID of the news liked
# - +user_id+ - (integer) - The ID of the user who liked
#
# ==== Associations
#
# - +belongs_to+ - :news
#
class Newslike < ActiveRecord::Base
  belongs_to :news
end