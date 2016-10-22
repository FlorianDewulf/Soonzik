require 'test_helper'

module API
  class PurchasesControllerTest < ActionController::TestCase
    def giveToken
      return { id: @user.id, secureKey: @user.secureKey }
    end
    
    setup do
      @user = users(:UserOne)
      @purchase = purchases(:PurchaseTwo)
    end

    test "should save purchase" do
      token = giveToken() # because of security access

      obj = nil
      type = ""
      if (@purchase.musics.size != 0)
        obj = @purchase.musics[0]
        type = "Music"
      elsif (@purchase.albums.size != 0)
        obj = @purchase.albums[0]
        type = "Album"
      elsif (@purchase.packs.size != 0)
        obj = @purchase.packs[0]
        type = "Pack"
      end

      assert_difference('Purchase.count') do
        post :save, { purchase: { obj_id: obj.id, typeObj: type, user_id: @purchase.user_id }, user_id: token[:id], secureKey: token[:secureKey], format: :json }
      end
      assert_response :created

      value = JSON.parse(response.body)
      assert_equal value["code"], 201
    end

    test "purchase of object which doesn't exist" do
      token = giveToken() # because of security access
      post :save, { purchase: { obj_id: 1234, typeObj: "Music", user_id: @purchase.user_id }, user_id: token[:id], secureKey: token[:secureKey], format: :json }
      assert_response :service_unavailable

      value = JSON.parse(response.body)
      assert_equal value["code"], 503
    end
  end
end