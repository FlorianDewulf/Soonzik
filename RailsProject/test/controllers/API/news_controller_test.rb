require 'test_helper'

module API
  class NewsControllerTest < ActionController::TestCase
    def giveToken
      return { id: @user.id, secureKey: @user.secureKey }
    end
    
    setup do
      @user = users(:UserOne)
      @news = news(:newsOne)
    end

    test "should get index" do
      get :index, format: :json
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
    end

    test "should show news ok" do
      get :show, { id: @news, format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"]["id"], @news.id
    end

    test "should show news ko" do
      get :show, id: 12345, format: :json
      assert_response :not_found

      value = JSON.parse(response.body)
      assert_equal value["code"], 502
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


      get :find, { limit: 1, offset: 0, attribute: { title: "%o%", date: "2014-09-07 23:19:17.000000" }, order_by_asc: ["author_id"], order_by_desc: ["title"], group_by: ["id"], format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"].size, 1
    end

    test "should add comment" do
      token = giveToken() # because of security access
      post :addcomment, { id: @news, content: "Ceci est un commentaire", user_id: token[:id], secureKey: token[:secureKey], format: :json }
      assert_response :created
    end
  end
end