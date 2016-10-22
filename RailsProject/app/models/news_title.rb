# The model of the object NewsTitle
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +title+ - (string) - The title
# - +language+ - (string) - The language of the title
# - +news_id+ - (string) - The id of the news who has the title
#
# ==== Associations
#
#  +:belongs_to+ - :users
#
class NewsTitle < ActiveRecord::Base
  belongs_to :news

  validates :title, :language, presence: true

  # Filter of information for the API
  #
  # Fields returned : [:title, :language]
  def self.miniKey
  	[:title, :language]
  end
end
