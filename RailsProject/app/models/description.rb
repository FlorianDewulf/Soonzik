# The model of the object Description
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +description+ - (string) - The description
# - +language+ - (string) - The language of the description
#
# ==== Associations
#
# - +has_and_belongs_to_many+ - :albums
# - +has_and_belongs_to_many+ - :musics
# - +has_and_belongs_to_many+ - :packs
# - +has_and_belongs_to_many+ - :genres
# - +has_and_belongs_to_many+ - :influences
#
class Description < ActiveRecord::Base
  has_and_belongs_to_many :albums
  has_and_belongs_to_many :packs

  accepts_nested_attributes_for :albums
  accepts_nested_attributes_for :packs
  attr_accessor :album_ids
  attr_accessor :pack_ids

  validates :description, :language, presence: true

  # The strong parameters to save or update object
  def self.description_params(parameters)
    parameters.require(:description).permit(:description, :language)
  end

  # The information filtered for the API
  #
  # Fields returned : [:id, :description, :language]
  def self.miniKey
  	[:id, :description, :language]
  end

  # for admin panel, to have selected checkbox
  def generateSelectedAlbumCollection
    collection = Album.pluck('title, id')
    collection.each do |collect|
      if ((self.album_ids) && self.album_ids.include?(collect[1]))
        collect[2] = { checked: true }
      else
        collect[2] = { checked: false }
      end
    end
    return collection
  end

  # for admin panel, to have selected checkbox
  def generateSelectedPackCollection
    collection = Pack.pluck('title, id')
    collection.each do |collect|
      if ((self.pack_ids) && self.pack_ids.include?(collect[1]))
        collect[2] = { checked: true }
      else
        collect[2] = { checked: false }
      end
    end
    return collection
  end
end
