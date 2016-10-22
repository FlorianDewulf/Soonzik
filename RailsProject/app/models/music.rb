# The model of the object Music
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +title+ - (string) - The name of the music
# - +user_id+ - (integer) - The ID of the artist
# - +album_id+ - (integer) - The ID of the album
# - +duration+ - (integer) - The duration in seconds
# - +price+ - (float) - The price of the music alone
# - +file+ - (string) - The name of the file
# - +limited+ - (boolean) - To know if the music is full for listening even if we don't buy it
#
# ==== Associations
#
# - +belongs_to+ - :album
# - +belongs_to+ - :user
# - +has_many+ - :listening
# - +has_many+ - :music_notes
# - +has_and_belongs_to_many+ - :commentaries
# - +has_and_belongs_to_many+ - :descriptions
# - +has_and_belongs_to_many+ - :playlist_objects
# - +has_and_belongs_to_many+ - :genres
# - +has_many+ - :purchased_musics
#
class Music < ActiveRecord::Base
  belongs_to :album
  belongs_to :user
  has_many :listenings
  has_many :music_notes
  has_and_belongs_to_many :ambiances
  has_and_belongs_to_many :commentaries
  has_and_belongs_to_many :playlist_objects
  has_and_belongs_to_many :genres

  has_many :purchased_musics

  accepts_nested_attributes_for :album

  validates :user, :title, :duration, :price, :file, presence: true
  validates :title, length: { minimum: 4, maximum: 30 }
  validates :price, :duration, numericality: true
  validates_inclusion_of :limited, :in => [true, false]

  # The strong parameters to save or update object
  def self.music_params(parameters)
    parameters.require(:music).permit(:user_id, :album_id, :title, :duration, :price, :file, :limited, album_attributes: [:id])
  end

  # Filter of information for the API
  #
  # Fields returned : [:id, :title, :duration, :price, :limited]
  def self.miniKey
    [:id, :title, :duration, :price, :limited]
  end

  # Set the average of notes
  def setAverageNote(value)
    @average = value
  end

  # Get the average of notes
  def getAverageNote
    return @average.present? ? @average : MusicNote.where(music_id: self.id).average(:value).to_f
  end

  # Fill an association of records of the notes average
  def self.fillAverageNote(ar_musics)
    if (ar_musics.size == 0)
      return
    end
    sql = "SELECT music_id, AVG(value) as average FROM music_notes WHERE (music_id IN ("

    ar_musics.each_with_index do |music, index|
      sql += ", " if index != 0
      sql += music[:id].to_s
    end

    sql += ")) GROUP BY music_id"
    records_array = ActiveRecord::Base.connection.execute(sql)

    ar_musics.each do |music|
      passIn = false

      records_array.each do |record|
        if (music[:id].to_i == record['music_id'].to_i)
          passIn = true
          music.setAverageNote record['average'].to_f
          break
        end
      end

      music.setAverageNote  0 if !passIn
    end
  end

  # Suggestion logic
  def self.suggest(user)
    index =           0
    gPond =           {}
    musicList =       []
    suggestionList =  []

    user.purchases.each { |purchase|        # => For each purchase
      purchase.musics.each { | music |      # => For each musics purchased
        music.genres.each { | genre_obj |   # => For each genre
          # If the genre is not in the hash, we init it, else we increment it 
          gPond[genre_obj] = (gPond.has_key?(genre_obj)) ? gPond[genre_obj] + 1 : 1
        }
        # The music is already purchased so we don't have to suggest it
        musicList << music 
      }
    }

    result = ActiveRecord::Base.connection.execute("SELECT COUNT(*), genre_id FROM musicalpasts WHERE user_id = #{user.id} GROUP BY genre_id")
    result.each { |r|
      if (r["COUNT(*)"] != 0)
        genre = Genre.find_by_id(r["genre_id"].to_i)
        gPond[genre] = (gPond.has_key?(genre)) ? gPond[genre] + 1 : 1
      end
    }

    # if our list is too small, we add a random genre to fill the suggestion list
    if (gPond.size < Genre.count)
      randomGenre = Genre.all
      gPond.each { |key, value|
        randomGenre = randomGenre.where.not(id: key.id)
      }
      randomGenre = randomGenre.offset(rand(randomGenre.count)).first
      gPond[randomGenre] = 0 if randomGenre != nil
    end

    # We sort by ponderation and transform it as an array [ [key, value], [key, value], ...]
    gPond = gPond.sort_by{|k,v| v}

    # While the list of suggestion is not filled or our list of genre is not finished
    while index < gPond.size && suggestionList.size < 10
      # We get the genre Object and its musics
      genreObject = gPond[index][0]
      listTmp = genreObject.musics.to_a

      # We sort it by notes
      listTmp.sort! { |music1, music2| music2.getAverageNote <=> music1.getAverageNote }
      
      # We remove the musics already purchased
      musicList.each { |musicToRemove|
        listTmp.delete(musicToRemove)
      }
      if (listTmp.size + suggestionList.size <= 10)
        suggestionList = suggestionList | listTmp
        musicList = musicList | listTmp
      else
        # To fill the suggestionList, we get random element of our new list
        suggestionList = suggestionList | listTmp[0..30].shuffle[0..(10 - suggestionList.size)]
      end
      index += 1
    end

    return suggestionList
  end

  # Algorithm to get musics for suggestv2
  def self.suggestMusic(u, limit)
    content = []
    if (u == nil)
      content = Music.musicToJson Music.joins(:music_notes).select('musics.*, AVG(music_notes.value) AS note').order("note DESC").group("musics.id").limit(limit * 2).shuffle[0..(limit)]
    else
      toRemove = Music.musicToJson Music.joins(purchased_musics: [:purchase]).where(["purchases.user_id = ?", u.id])
      interesting = Music.musicToJson Music.joins(:listenings).where(["listenings.user_id = ?", u.id])
      u.friends.each do |friend|
        interesting = interesting | (Music.musicToJson Music.joins(purchased_musics: [:purchase]).where(["purchases.user_id = ?", friend.id]))
        friend.listenings.limit(30).each do |listening|
          interesting = interesting | [Music.musicToJson(listening.music)]
        end
      end

      content = interesting - toRemove
      content = content.shuffle
      content = content[0..(limit + 10)]
    end

    return content
  end

  # To render the object as json (for suggestv2 only)
  def self.musicToJson(m)
    return m.as_json(only: Music.miniKey, methods: :getAverageNote, :include => { user: { only: User.miniKey }, album: { only: Album.miniKey } })
  end

end
