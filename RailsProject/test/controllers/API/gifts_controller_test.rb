require 'test_helper'

module API
  class GiftsControllerTest < ActionController::TestCase
    def giveToken
      return { id: @user.id, secureKey: @user.secureKey }
    end
    
    setup do
      @user = users(:UserOne)
      @gift = gifts(:cadeauDeux)
    end

    test "should save gift" do
      token = giveToken() # because of security access
      
      obj = nil
      type = ""
      if (@gift.musics.size != 0)
        obj = @gift.musics[0]
        type = "Music"
      elsif (@gift.albums.size != 0)
        obj = @gift.albums[0]
        type = "Album"
      elsif (@gift.packs.size != 0)
        obj = @gift.packs[0]
        type = "Pack"
      end

      assert_difference('Gift.count') do
        post :save, { gift: { from_user: @gift.from_user, obj_id: obj.id, to_user: @gift.to_user, typeObj: type }, user_id: token[:id], secureKey: token[:secureKey], format: :json }
      end
      assert_response :created

      value = JSON.parse(response.body)
      assert_equal value["code"], 201
    end

    test "gift of object which doesn't exist" do
      token = giveToken() # because of security access
      post :save, { gift: { from_user: @gift.from_user, obj_id: 1234, to_user: @gift.to_user, typeObj: "Music" }, user_id: token[:id], secureKey: token[:secureKey], format: :json }
      assert_response :service_unavailable

      value = JSON.parse(response.body)
      assert_equal value["code"], 503
    end
  end
end