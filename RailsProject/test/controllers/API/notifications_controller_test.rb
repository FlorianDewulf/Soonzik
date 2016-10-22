require 'test_helper'

module API
  class NotificationsControllerTest < ActionController::TestCase
    def giveToken
      return { id: @user.id, secureKey: @user.secureKey }
    end
    
    setup do
      @user = users(:UserOne)
      @notification = notifications(:NotifOne)
    end

    test "should save notification" do
      token = giveToken() # because of security access
      assert_difference('Notification.count') do
        post :save, { notification: { description: @notification.description, link: @notification.link, user_id: @notification.user_id }, user_id: token[:id], secureKey: token[:secureKey], format: :json }
      end
      assert_response :created

      value = JSON.parse(response.body)
      assert_equal value["code"], 201
    end

    test "should show notification ok" do
      token = giveToken() # because of security access
      get :show, { id: @notification, user_id: token[:id], secureKey: token[:secureKey], format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"]["id"], @notification.id
    end

    test "should show notification ko" do
      token = giveToken() # because of security access
      get :show, id: 12345, user_id: token[:id], secureKey: token[:secureKey], format: :json
      assert_response :not_found

      value = JSON.parse(response.body)
      assert_equal value["code"], 502
    end

    test "should get find - all cases" do
      token = giveToken() # because of security access
      get :find, { order_by_asc: ["id"], user_id: token[:id], secureKey: token[:secureKey], format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"].size, 1

      @user = users(:UserTwo)
      token = giveToken()
      get :find, { offset: 42, order_by_asc: [], order_by_desc: ["id"], user_id: token[:id], secureKey: token[:secureKey], format: :json }
      assert_response :ok
      value = JSON.parse(response.body)
      assert_equal value["code"], 202

      value = JSON.parse(response.body)
      assert_equal value["code"], 202
      assert_equal value["content"].size, 0

      @user = users(:UserOne)
      @user.reload
      token = giveToken()
      get :find, { limit: 1, offset: 0, attribute: { link: "%notification%", user_id: "213118761" }, order_by_asc: ["link"], order_by_desc: ["description"], group_by: ["id"], user_id: token[:id], secureKey: token[:secureKey], format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"].size, 1
    end

    test "should destroy notification" do
      token = giveToken() # because of security access
      assert_difference('Notification.count', -1) do
        get :destroy, { id: @notification, user_id: token[:id], secureKey: token[:secureKey], format: :json }
      end
      assert_response :ok
      value = JSON.parse(response.body)
      assert_equal value["code"], 202

      value = JSON.parse(response.body)
      assert_equal value["code"], 202
    end
  end
end