# The model of the object Concert
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +planification+ - (date) - The date of the event
# - +url+ - (string) - (Facultative) The url of the event (for example)
# - +user_id+ - (integer) - ID of the artist
#
# ==== Associations
#
# - +belongs_to+ - :user
# - +has_and_belongs_to_many+ - :albums
# - +has_and_belongs_to_many+ - :musics
# - +has_and_belongs_to_many+ - :news
#
class Concert < ActiveRecord::Base
  belongs_to :address
  belongs_to :user
  has_many :concertslikes

  validates :user, :address, :planification, presence: true
  validates :planification, format: /(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/

  # Filter of information for the API
  #
  # Fields returned : [:id, :planification, :url]
  def self.miniKey
  	[:id, :planification, :url]
  end

  # Fill an association of records of the notes average
  def self.fillLikes(ar_concerts, security = false, user_id = nil)
    if (ar_concerts.size == 0)
      return
    end
    sql_count = "SELECT concert_id, COUNT(concert_id) AS count FROM concertslikes WHERE (concert_id IN ("
    sql_hasLiked = "SELECT concert_id FROM concertslikes WHERE (concert_id IN (" if security

    ar_concerts.each_with_index do |concert, index|
      sql_count += ", " if index != 0
      sql_count += concert[:id].to_s

      if security
        sql_hasLiked += ", " if index != 0
        sql_hasLiked += concert[:id].to_s
      end
    end

    sql_count += ")) GROUP BY concert_id"
    records_array = ActiveRecord::Base.connection.execute(sql_count)

    if security
      sql_hasLiked += ")) AND user_id = #{user_id}"
      records_liked = ActiveRecord::Base.connection.execute(sql_hasLiked)
    end

    ar_concerts.each do |concert|
      passIn = false

      records_array.each do |record|
        if (concert[:id].to_i == record['concert_id'].to_i)
          passIn = true
          concert.setLike record['count']
          break
        end
      end

      if security
        records_liked.each do |record|
          if (concert[:id].to_i == record['concert_id'].to_i)
            concert.setLiked
          end
        end
      end

      concert.setLike 0 if !passIn
    end
  end

  # Set the number of likes
  def setLike(value)
    @likes = value
  end

  # Return the number of likes
  def likes
    return (@likes.present?) ? @likes : ActiveRecord::Base.connection.execute("SELECT COUNT(concert_id) AS count FROM concertslikes WHERE concert_id = #{self.id.to_s}")[0]["count"]
  end

  # The strong parameters to save or update object
  def self.concert_params(parameters)
    parameters.require(:concert).permit(:user_id, :planification, :address_id, :url)
  end

  # Set the number of likes
  def setLiked
    @hasLiked = true
  end

  # To know if you liked this
  def hasLiked
    return @hasLiked.present? ? @hasLiked : false
  end
end
