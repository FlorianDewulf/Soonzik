require 'test_helper'

module API
  class AlbumsControllerTest < ActionController::TestCase
    def giveToken
      return { id: @user.id, secureKey: @user.secureKey }
    end
    
    setup do
      @album = albums(:AlbumOne)
      @user = users(:UserOne)
    end

    test "should get index" do
      get :index, format: :json
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
    end

    test "should show album ok" do
      get :show, id: @album, format: :json
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"]["id"], @album.id
    end

    test "should show album ko" do
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

      get :find, { offset: 42, order_by_asc: [], order_by_desc: ["price"], format: :json }
      assert_response :ok
      value = JSON.parse(response.body)
      assert_equal value["code"], 202

      value = JSON.parse(response.body)
      assert_equal value["code"], 202
      assert_equal value["content"].size, 0


      get :find, { limit: 1, offset: 0, attribute: { price: "1.5", user_id: "%1%" }, order_by_asc: ["id"], order_by_desc: ["price"], group_by: ["id"], format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"].size, 1
    end

    test "should add comment" do
      user = users(:UserOne)
      post :addcomment, { id: @album, content: "lol", user_id: user.id, secureKey: Digest::SHA256.hexdigest(user.salt + user.idAPI), format: :json }
      assert_response :created
      value = JSON.parse(response.body)
      assert_equal value["code"], 201
    end

    test "should fail add comment - not available album" do
      user = users(:UserOne)
      post :addcomment, { id: 42, content: "lol", user_id: user.id, secureKey: Digest::SHA256.hexdigest(user.salt + user.idAPI), format: :json }
      assert_response :not_found
      value = JSON.parse(response.body)
      assert_equal value["code"], 502
    end

    test "should fail add comment - too short" do
      user = users(:UserOne)
      post :addcomment, { id: @album, content: "a", user_id: user.id, secureKey: Digest::SHA256.hexdigest(user.salt + user.idAPI), format: :json }
      assert_response :service_unavailable
      value = JSON.parse(response.body)
      assert_equal value["code"], 503
    end
  end
end