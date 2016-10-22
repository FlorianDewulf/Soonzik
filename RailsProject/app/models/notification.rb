# The model of the object Notification
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +user_id+ - (integer) - The ID of the user
# - +link+ - (string) - The link to see what about the notification is
# - +description+ - (string) - The text inside the notification
#
# ==== Associations
#
# - +belongs_to+ - :user
#
class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :from, class_name: "User", foreign_key: 'from_user_id'

  validates :user, :notif_type, :from, presence: true
	validates_inclusion_of :read, :in => [true, false]

  # The strong parameters to save or update object
  def self.notification_params(parameters)
    parameters.require(:notification).permit(:user_id, :link, :description)
  end

  # Filter of information for the API
  #
  # Fields returned : [:id, :title, :date]
  def self.miniKey
    [:id, :created_at, :notif_type, :read, :link]
  end
end
