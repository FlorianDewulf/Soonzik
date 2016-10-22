# The model of the object PaypalPayment
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Associations
#
#  +:belongs_to+ - :purchase
#
class PaypalPayment < ActiveRecord::Base
  belongs_to :purchase
end
