require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "Public method of User model" do
  	u1 = users(:UserOne)

  	secureKey = User.secureKey_hash("test")
  	u1.password = Devise.friendly_token
  	salt = u1.salt_hash

  	assert secureKey.is_a?(String) && secureKey.size == 40
  	assert salt.is_a?(String) && salt.size == 40

  	oldidApi = u1.idAPI
  	oldKey = u1.secureKey

  	assert u1.regenerateKey
  	assert u1.idAPI != oldidApi
  	assert u1.secureKey != oldKey
    u1.skip_confirmation!
    assert u1.save
  end

  test "User before create method" do
  	u = User.new
  	u.email = "don't_work_mail"
  	u.password = nil
  	u.image = nil
  	u.newsletter = nil
  	u.username = "Bob"
  	u.birthday = "1998-12-30 00:00:00"
  	u.language = "FR"
  	u.groups << groups(:userGroup)

  	u.send(:beforeCreate)
  	assert_equal u.image, "default.png"
  	assert u.newsletter
  	assert_not u.valid?

  	u.password = "password"
  	u.birthday = "1998-12-30"
  	assert_not u.save
  	
  	u.email = "lol@mdr.fr"
  	u.username = "Lund"
  	u.send(:beforeCreate)
    u.skip_confirmation!
  	toto = u.save
    assert toto
  end
end
