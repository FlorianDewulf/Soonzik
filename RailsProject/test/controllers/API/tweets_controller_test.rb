require 'test_helper'

module API
  class TweetsControllerTest < ActionController::TestCase
    def giveToken
      return { id: @user.id, secureKey: @user.secureKey }
    end
    
    setup do
      @user = users(:UserOne)
      @tweet = tweets(:TweetOne)
    end

    test "should get index" do
      get :index, format: :json
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
    end

    test "should save tweet" do
      token = giveToken() # because of security access
      assert_difference('Tweet.count') do
        post :save, { tweet: { msg: "ceci est un tweet", user_id: token[:id] }, user_id: token[:id], secureKey: token[:secureKey], format: :json }
      end
      assert_response :created

      value = JSON.parse(response.body)
      assert_equal value["code"], 201
    end

    test "should show tweet" do
      get :show, { id: @tweet, format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"]["id"], @tweet.id
    end

    test "should get find - all cases" do
      get :find, { order_by_asc: ["id"], format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"].size, 2

      get :find, { offset: 42, order_by_asc: [], order_by_desc: ["id"], format: :json }
      assert_response :ok
      value = JSON.parse(response.body)
      assert_equal value["code"], 202

      value = JSON.parse(response.body)
      assert_equal value["code"], 202
      assert_equal value["content"].size, 0


      get :find, { limit: 1, offset: 0, attribute: { msg: "%Tweet%", user_id: "213118761" }, order_by_asc: ["msg"], order_by_desc: ["user_id"], group_by: ["id"], format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"].size, 1
    end

    test "should destroy tweet" do
      token = giveToken() # because of security access
      assert_difference('Tweet.count', -1) do
        get :destroy, { id: @tweet, user_id: token[:id], secureKey: token[:secureKey], format: :json }
      end
      assert_response :ok
      value = JSON.parse(response.body)
      assert_equal value["code"], 202

      value = JSON.parse(response.body)
      assert_equal value["code"], 202
    end
  end
end