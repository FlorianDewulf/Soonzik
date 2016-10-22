# The model of the object Commentary
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +author_id+ - (integer) - The ID of the author
# - +content+ - (string) - The commentary
#
# ==== Associations
#
# - +belongs_to+ - :user
# - +has_and_belongs_to_many+ - :albums
# - +has_and_belongs_to_many+ - :musics
# - +has_and_belongs_to_many+ - :news
#
class Commentary < ActiveRecord::Base
  belongs_to :user, class_name: 'User', foreign_key: 'author_id'
  has_and_belongs_to_many :news
  has_and_belongs_to_many :albums
  has_and_belongs_to_many :musics
  attr_accessor :album_ids
  attr_accessor :news_ids

  validates :user, :content, presence: true
  validates :content, length: { minimum: 2 }

  # The strong parameters to save or update object
  def self.commentary_params(parameters)
    parameters.require(:commentary).permit(:author_id, :content)
  end

  # Filter of information for the API
  #
  # Fields returned : [:id, :author_id, :content, :created_at]
  def self.miniKey
    [:id, :author_id, :content, :created_at]
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
  def generateSelectedNewsCollection
    collection = []
    collectionObj = News.eager_load(:newstexts).all
    collectionObj.each do |collect|
      if ((self.news_ids) && self.news_ids.include?(collect.id))
        collection << [collect.title, collect.id, { checked: true }]
      else
        collection << [collect.title, collect.id, { checked: false }]
      end
    end
    return collection
  end
end
