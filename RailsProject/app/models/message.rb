# The model of the object Message
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +msg+ - (string) - The name of the group
# - +user_id+ - (integer) - The latitude of the position
# - +dest_id+ - (integer) - The longitude of the position
# - +session+ - (string) - Useless, need to be delete
#
# ==== Associations
#
# - +belongs_to+ - :sender [user object]
# - +belongs_to+ - :receiver [user object]
#
class Message < ActiveRecord::Base
  belongs_to :sender, class_name: 'User', foreign_key: 'user_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'dest_id'


  validates :sender, :receiver, :msg, presence: true
  validates :msg, length: { minimum: 1 }

  # The strong parameters to save or update object
  def self.message_params(parameters)
    parameters.require(:message).permit(:msg, :user_id, :dest_id)
  end

  # Filter of information for API
  #
  # Fields returned : [:id, :msg, :user_id, :dest_id]
  def self.miniKey
  	[:id, :msg, :user_id, :dest_id]
  end

  # Function for the chat to get the user who do the request
  def self.checkKey(message, current_user = nil)
    user = nil
    if (message.has_key?("user_id") && message.has_key?("secureKey"))
      begin
        user = User.where(id: message["user_id"]).where(secureKey: message["secureKey"]).first
      rescue
      end
    elsif (current_user != nil)
      user = current_user
    end
    return user
  end
end
