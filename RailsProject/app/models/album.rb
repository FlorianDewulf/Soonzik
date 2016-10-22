# The model of the object Album
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +user_id+ - (integer) - The ID of the artist who own the album
# - +title+ - (string) - The title of the album
# - +image+ - (string) - The image of the album (the name of the image, not the filename !)
# - +price+ - (float) - The price of the album
# - +file+ - (string) - The name of the file to find it
# - +yearProd+ - (integer) - The year of production when the album was released
#
# ==== Associations
#
# - +has_and_belongs_to_many+ - :descriptions
# - +has_and_belongs_to_many+ - :genres
# - +has_and_belongs_to_many+ - :packs
# - +has_and_belongs_to_many+ - :commentaries
# - +has_many+ - :album_notes
# - +has_many+ - :propositions
# - +has_many+ - :musics
# - +has_many+ - :purchased_albums
# - +belongs_to+ - :user
#
class Album < ActiveRecord::Base
  has_and_belongs_to_many :descriptions
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :packs
  has_and_belongs_to_many :commentaries
  has_many :propositions
  has_many :musics
  belongs_to :user

  has_many :purchased_albums

  accepts_nested_attributes_for :musics, allow_destroy: true
  accepts_nested_attributes_for :genres
  accepts_nested_attributes_for :packs
  attr_accessor :music_ids
  attr_accessor :genre_ids
  attr_accessor :pack_ids

  validates :user, :title, :price, :file, :yearProd, :image, presence: true
  validates :yearProd, numericality: { only_integer: true }

  # The strong parameters to save or update object
  def self.album_params(parameters)
    parameters.require(:album).permit(:user_id, :title, :price, :file, :yearProd, :image )
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

  # Filter of information for the API
  #
  # Fields returned : [:id, :title, :price, :image, :yearProd]
  def self.miniKey
    [:id, :title, :price, :image, :yearProd]
  end

  # To join tables in sql query
  def self.sql_join
    self.joins('LEFT OUTER JOIN "users" ON "users"."id" = "albums"."user_id" LEFT OUTER JOIN "musics" ON "musics"."album_id" = "albums"."id" LEFT OUTER JOIN "albums_descriptions" ON "albums_descriptions"."album_id" = "albums"."id" LEFT OUTER JOIN "descriptions" ON "descriptions"."id" = "albums_descriptions"."description_id"')
  end

  # Get the average of notes
  def getAverageNote
    notes = 0
    if (self.musics.size > 0)
      self.musics.each do |music|
        notes += music.getAverageNote
      end
      notes = notes / self.musics.size
    end
    return notes
  end

  # Fill an association of records of the notes average
  def self.fillLikes(ar_albums, security = false, user_id = nil)
    if (ar_albums.size == 0)
      return
    end
    sql_count = "SELECT album_id, COUNT(album_id) AS count FROM albumslikes WHERE (album_id IN ("
    sql_hasLiked = "SELECT album_id FROM albumslikes WHERE (album_id IN (" if security

    ar_albums.each_with_index do |album, index|
      sql_count += ", " if index != 0
      sql_count += album[:id].to_s

      if security
        sql_hasLiked += ", " if index != 0
        sql_hasLiked += album[:id].to_s
      end
    end

    sql_count += ")) GROUP BY album_id"
    records_array = ActiveRecord::Base.connection.execute(sql_count)

    if security
      sql_hasLiked += ")) AND user_id = #{user_id}"
      records_liked = ActiveRecord::Base.connection.execute(sql_hasLiked)
    end

    ar_albums.each do |album|
      passIn = false

      records_array.each do |record|
        if (album[:id].to_i == record['album_id'].to_i)
          passIn = true
          album.setLike record['count']
          break
        end
      end

      if security
        records_liked.each do |record|
          if (album[:id].to_i == record['album_id'].to_i)
            album.setLiked
          end
        end
      end

      album.setLike 0 if !passIn
    end
  end

  # Add an attribute to know if it's an album proposed
  def setProposed(value)
    @proposed = value
  end

  # To know if the album is in the pack
  def setPack(value)
    @pack_id = value
  end

  # Set the number of likes
  def setLike(value)
    @likes = value
  end

  # Set the number of likes
  def setLiked
    @hasLiked = true
  end

  # Get an attribute to know if it's an album proposed
  def getProposed
    @proposed
  end

  # To know if the album is in the pack
  def isPartial
    if (@pack_id.present?)
      PartialAlbum.where(album_id: self.id).where(pack_id: @pack_id).size > 0
    else
      nil
    end
  end

  # Return the number of likes
  def likes
    return (@likes.present?) ? @likes : ActiveRecord::Base.connection.execute("SELECT COUNT(album_id) AS count FROM albumslikes WHERE album_id = #{self.id.to_s}")[0]["count"]
  end

  # To know if you liked this
  def hasLiked
    return @hasLiked.present? ? @hasLiked : false
  end
end
