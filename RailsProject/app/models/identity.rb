# The model of the object Identity
# Contain the relation and the validation
# Can provide some features linked to this model
#
# This model is used for social network connection.
# The salt that the smartphone application need to use for the login thanks to social network is :
# "3uNi@rCK$L$om40dNnhX)#jV2$40wwbr_bAK99%E"
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +provider+ - (string) - The name of the website
# - +user_id+ - (integer) - Our user_id
# - +uid+ - (integer) - The user_id on the website
# - +token+ - (string) - The token for auth
#
# ==== Associations
#
# - +belongs_to+ - :user
#
class Identity < ActiveRecord::Base
	before_validation :newToken, on: :create

  belongs_to :user
  validates_presence_of :uid, :provider, :token
  validates_uniqueness_of :uid, :scope => :provider

  SALT = "3uNi@rCK$L$om40dNnhX)#jV2$40wwbr_bAK99%E"

  # The strong parameters to save or update object
  def self.identity_params(parameters)
    parameters.require(:identity).permit(:provider, :uid)
  end

  # Find or create an user by the oauth value
  def self.find_for_oauth(auth)
    find_or_create_by(uid: auth.uid, provider: auth.provider)
  end

  # Create a new token
  def newToken
  	key = nil
  	begin
      key = Identity.tokenGenerator
    end while (Identity.find_by_token(key))
    self.token = key
  end

  # Return a new random token
  def self.tokenGenerator
		sha256 = Digest::SHA1.new

    key = ""
    example = ('a'..'z').to_a.concat(('A'..'Z').to_a.concat(('0'..'9').to_a)).shuffle[0,48].join
    48.times do
      key += example[Random.rand(example.size)]
    end

    return sha256.hexdigest key
 	end

  # Create an identity if doesn't exist, or update the old one
  def self.updateOrCreate(user_id, provider, uid)
    obj = Identity.where(provider: provider).where(user_id: user_id).first

    if (obj == nil)
      o = Identity.new
      o.uid = uid
      o.provider = provider
      o.user_id = user_id
      o.save

      return o
    elsif (obj.uid != uid.to_i)
      obj.uid = uid
      obj.save
    end

    return obj
  end
end
