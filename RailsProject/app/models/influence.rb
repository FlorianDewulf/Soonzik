# The model of the object Influence
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
# - +has_and_belongs_to_many+ - :descriptions
# - +has_and_belongs_to_many+ - :genres
#
class Influence < ActiveRecord::Base
  has_and_belongs_to_many :genres

  validates :name, presence: true, format: /([A-Za-z]+)/, uniqueness: true

  # Filter of information for the API
  #
  # Fields returned : [:id, :name]
  def self.miniKey
  	[:id, :name]
  end

  # The strong parameters to save or update object
  def self.influence_params(parameters)
    parameters.require(:influence).permit(:name)
  end

  # for admin panel, to have selected checkbox
  def generateSelectedGenreCollection
    collection = Genre.pluck('style_name, id')
    collection.each do |collect|
      if ((self.genre_ids) && self.genre_ids.include?(collect[1]))
        collect[2] = { checked: true }
      else
        collect[2] = { checked: false }
      end
    end
    return collection
  end
end
