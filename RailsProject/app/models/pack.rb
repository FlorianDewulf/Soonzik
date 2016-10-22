# The model of the object Pack
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +association_id+ - (integer) - The ID of the association linked with this pack
# - +title+ - (string) - The name of the pack
#
# ==== Associations
#
# - +belongs_to+ - :user
# - +has_and_belongs_to_many+ - :albums
# - +has_and_belongs_to_many+ - :genres
# - +has_and_belongs_to_many+ - :descriptions
#
class Pack < ActiveRecord::Base
  has_and_belongs_to_many :albums
  has_and_belongs_to_many :descriptions
  belongs_to :user, foreign_key: 'association_id'

  has_many :purchased_packs
  has_many :partial_albums

  validates :title, :begin_date, :end_date, :minimal_price, presence: true

  # The strong parameters to save or update object
  def self.pack_params(parameters)
    parameters.require(:pack).permit(:title)
  end

  # Filter of information for the API
  #
  # Fields returned : [:id, :title, begin_date, end_date, minimal_price]
  def self.miniKey
  	[:id, :title, :begin_date, :end_date, :minimal_price]
  end

  # Calculate the average of donation for this pack
  def averagePrice
    id = self.id
    average = 0.0
    pp = PurchasedPack.where(pack_id: id).all

    pp.each do |purchase|
      average += purchase.value
    end

    average = average / pp.size if pp.size > 0
    average = self.minimal_price if pp.size == 0
    return average
  end
end
