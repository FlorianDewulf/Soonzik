# The model of the object News
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +author_id+ - (integer) - The ID of the user
# - +title+ - (string) - The title of the news (need to change for multi language)
# - +news_type+ - (string) - The type of news (example : "discovery", "promotion", "information"...)
#
# ==== Associations
#
# - +belongs_to+ - :user
# - +has_many+ - :newstexts
# - +has_and_belongs_to_many+ - :attachments
# - +has_and_belongs_to_many+ - :commentaries
#
class News < ActiveRecord::Base
  after_initialize :myConstructor

  belongs_to :user, class_name: 'User', foreign_key: 'author_id'
  has_many :newstexts
  has_many :news_titles
  has_many :newslikes
  has_and_belongs_to_many :attachments
  has_and_belongs_to_many :commentaries

  validates :user, :title, presence: true

  # My constructor called after activerecord create the object ; it init the default language
  def myConstructor
    @language = "EN"
  end

  # Filter of information for the API
  #
  # Fields returned : [:id, :title, :date]
  def self.miniKey
    [:id, :created_at]
  end

  # override
  def to_s
    return "News #{self.id}"
  end

  # Fill an association of records of the notes average
  def self.fillLikes(ar_news, security = false, user_id = nil)
    if (ar_news.size == 0)
      return
    end
    sql = "SELECT news_id, COUNT(news_id) AS count FROM newslikes WHERE (news_id IN ("
    sql_hasLiked = "SELECT news_id FROM newslikes WHERE (news_id IN (" if security

    ar_news.each_with_index do |news, index|
      sql += ", " if index != 0
      sql += news[:id].to_s

      if security
        sql_hasLiked += ", " if index != 0
        sql_hasLiked += news[:id].to_s
      end
    end

    sql += ")) GROUP BY news_id"
    records_array = ActiveRecord::Base.connection.execute(sql)

    if security
      sql_hasLiked += ")) AND user_id = #{user_id}"
      records_liked = ActiveRecord::Base.connection.execute(sql_hasLiked)
    end

    ar_news.each do |news|
      passIn = false

      records_array.each do |record|
        if (news[:id].to_i == record['news_id'].to_i)
          passIn = true
          news.setLike record['count']
          break
        end
      end

      if security
        records_liked.each do |record|
          if (news[:id].to_i == record['news_id'].to_i)
            news.setLiked
          end
        end
      end

      news.setLike 0 if !passIn
    end
  end

  # Set the number of likes
  def setLike(value)
    @likes = value
  end

  # Return the number of likes
  def likes
    return (@likes.present?) ? @likes : ActiveRecord::Base.connection.execute("SELECT COUNT(news_id) AS count FROM newslikes WHERE news_id = #{self.id.to_s}")[0]["count"]
  end

  # The strong parameters to save or update object
  def self.news_params(parameters)
    parameters.require(:news).permit(:title, :author_id)
  end

  # To give the title of the good language
  def setLanguage(language)
    if (Language.where(abbreviation: language).size != 0)
      @language = language
    end
  end

  # To give the title of the good language
  def title
    title = "No Title"
    if (@language.present?)
      nt = NewsTitle.where(news_id: self.id).where(language: @language)
      if (nt != nil && nt.size > 0)
        title = nt.first.title
      end
    end

    title
  end

  # To give the content of the good language
  def content
    content = "No Content"
    if (@language.present?)
      nt = Newstext.where(news_id: self.id).where(language: @language)
      if (nt != nil && nt.size > 0)
        content = nt.first.content
      end
    end

    content
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
