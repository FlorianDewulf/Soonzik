# The model of the object Address
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +email+ - (string) - The email to contact
# - +user_id+ - (integer) - The email to contact
# - +type_object+ - (string) - The type of object (the category)
# - +object+ - (string) - The object of the feedback
# - +text+ - (string) - The content of the feedback
#
# ==== Associations
#
#  +:belongs_to+ - :user
#
class Feedback < ActiveRecord::Base
  belongs_to :user

  validates :email, :type_object, :object, :text, presence: true
  validates :email, format: /\A[a-zA-Z0-9_.+\-]+@[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-.]+\z/
  validates :type_object, :inclusion => { :in => ["bug", "payment", "account", "other"] }

  # The strong parameters to save or update object
  def self.feedback_params(parameters)
    parameters.require(:feedback).permit(:email, :type_object, :object, :text)
  end
end
