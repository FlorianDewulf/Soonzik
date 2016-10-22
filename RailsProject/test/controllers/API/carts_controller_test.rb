require 'test_helper'

module API
  class CartsControllerTest < ActionController::TestCase
    def giveToken
      return { id: @user.id, secureKey: @user.secureKey }
    end

    setup do
      @cart = carts(:panierUn)
      @user = users(:UserOne)
    end

    test "should get find - success" do
      token = giveToken() # because of security access
      get :find, { order_by_asc: ["id"], user_id: token[:id], secureKey: token[:secureKey], format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"].size, 1
    end

    test "should get find - fail" do
      @user = users(:UserTwo)
      token = giveToken()
      get :find, { offset: 42, user_id: token[:id], secureKey: token[:secureKey], format: :json }
      assert_response :ok
      value = JSON.parse(response.body)
      assert_equal value["code"], 202

      value = JSON.parse(response.body)
      assert_equal value["code"], 202
      assert_equal value["content"].size, 0
    end

    test "should save cart" do
      token = giveToken() # because of security access
      album = albums(:AlbumOne)
      assert_difference('Cart.count') do
        post :save, { id: @cart, cart: { gift: true, obj_id: album.id, typeObj: "Album", user_id: @cart.user_id }, user_id: token[:id], secureKey: token[:secureKey], format: :json }
      end
      assert_response :created

      value = JSON.parse(response.body)
      assert_equal value["code"], 201
    end

    test "should destroy cart" do
      token = giveToken() # because of security access
      assert_difference('Cart.count', -1) do
        get :destroy, { id: @cart, user_id: token[:id], secureKey: token[:secureKey], format: :json}
      end
      assert_response :ok
      value = JSON.parse(response.body)
      assert_equal value["code"], 202

      value = JSON.parse(response.body)
      assert_equal value["code"], 202
    end
  end
end