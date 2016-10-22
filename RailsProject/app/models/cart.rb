# The model of the object Cart
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +user_id+ - (integer) - The ID of the user who own it
#
# ==== Associations
#
# - +belongs_to+ - :user
# - +has_and_belongs_to_many+ - :albums
# - +has_and_belongs_to_many+ - :musics
# - +has_and_belongs_to_many+ - :packs
#
class Cart < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :albums
  has_and_belongs_to_many :musics

  accepts_nested_attributes_for :albums
  accepts_nested_attributes_for :musics
  attr_accessor :music_ids
  attr_accessor :album_ids

  validates :user, presence: true

  # The strong parameters to save or update object
  def self.cart_params(parameters)
    parameters.require(:cart).permit(:user_id)
  end

  # Filter of information for the API
  #
  # Fields returned : [:id, :created_at]
  def self.miniKey
    [:id, :created_at]
  end

  # for admin panel, to have selected checkbox
  def generateSelectedMusicCollection
    collection = Music.pluck('title, id')
    collection.each do |collect|
      if ((self.music_ids) && self.music_ids.include?(collect[1]))
        collect[2] = { checked: true }
      else
        collect[2] = { checked: false }
      end
    end
    return collection
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
end
