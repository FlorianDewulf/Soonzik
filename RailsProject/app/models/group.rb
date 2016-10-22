# The model of the object Group
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +name+ - (string) - The name of the group
#
# ==== Associations
#
# - +has_many+ - :accesses (Not sure if we will keep it)
# - +has_and_belongs_to_many+ - :users
#
class Group < ActiveRecord::Base
  has_and_belongs_to_many :users

  validates :name, presence: true, uniqueness: true, format: /([A-Za-z]+)/

  # The strong parameters to save or update object
  def self.group_params(parameters)
    parameters.require(:group).permit(:name)
  end
end
