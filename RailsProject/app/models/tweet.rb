# The model of the object Tweet
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +user_id+ - (integer) - The ID of the user
# - +msg+ - (string) - The content of the tweet
#
# ==== Associations
#
# - +belongs_to+ - :user
#
class Tweet < ActiveRecord::Base
  belongs_to :user

  validates :msg, :user, presence: true
  validates :msg, length: { maximum: 140 }

  # Filter of information for the API
  #
  # Fields returned : [:id, :msg]
  def self.miniKey
  	[:id, :msg, :created_at]
  end
  
  # The strong parameters to save or update object
  def self.tweet_params(parameters)
    parameters.require(:tweet).permit(:msg, :user_id)
  end
end
