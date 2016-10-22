# The model of the object Address
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +numberStreet+ - (string) - The number in the street. Is a string because of the "bis"
# - +complement+ - (string) - Facultative, necessary for flat (for example)
# - +street+ - (string) - The street of the address
# - +city+ - (string) - The city of the address
# - +country+ - (string) - The country of the address
# - +zipcode+ - (string) - Zipcode of the address. Is a string because in some country there are letters
#
# ==== Associations
#
#  +:has_many+ - :users
#  +:has_many+ - :concerts
#
class Address < ActiveRecord::Base
  has_many :users
  has_many :concerts

  validates :numberStreet, :street, :city, :country, :zipcode, presence: true

  # Filter of information for the API
  #
  # Fields returned : [:id, :numberStreet, :street, :city, :country, :zipcode]
  def self.miniKey
  	[:id, :numberStreet, :street, :city, :country, :zipcode, :complement]
  end

  # The strong parameters to save or update object
  def self.address_params(parameters)
    parameters.require(:address).permit(:numberStreet, :street, :city, :country, :zipcode, :complement)
  end

  # override
  def to_s
    return "#{self.numberStreet} #{self.street} #{self.complement} #{self.city} #{self.zipcode} #{self.country}"
  end
end
