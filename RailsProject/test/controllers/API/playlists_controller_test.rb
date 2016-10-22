require 'test_helper'

module API
  class PlaylistsControllerTest < ActionController::TestCase
    def giveToken
      return { id: @user.id, secureKey: @user.secureKey }
    end
    
    setup do
      @user = users(:UserOne)
      @playlist = playlists(:PlaylistOne)
    end

    test "should save playlist" do
      token = giveToken() # because of security access
      assert_difference('Playlist.count') do
        post :save, { playlist: { name: @playlist.name, user_id: @playlist.user_id }, user_id: token[:id], secureKey: token[:secureKey], format: :json }
      end
      assert_response :created

      value = JSON.parse(response.body)
      assert_equal value["code"], 201
    end

    test "should show playlist" do
      get :show, { id: @playlist, format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"]["id"], @playlist.id
    end

    test "should find playlist" do
      get :find, { order_by_asc: ["id"], format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"].size, 2

      get :find, { offset: 42, order_by_asc: [], order_by_desc: ["name"], format: :json }
      assert_response :ok
      value = JSON.parse(response.body)
      assert_equal value["code"], 202

      value = JSON.parse(response.body)
      assert_equal value["code"], 202
      assert_equal value["content"].size, 0


      get :find, { limit: 1, offset: 0, attribute: { name: "%t%", user_id: users(:UserOne).id }, order_by_asc: ["id"], order_by_desc: ["name"], group_by: ["id"], format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"].size, 1
    end

    test "should update playlist" do
      token = giveToken() # because of security access
      musicToAdd = musics(:MusicOne)
      post :update, { id: @playlist, playlist: { name: @playlist.name, user_id: @playlist.user_id, music: [musicToAdd.id] }, user_id: token[:id], secureKey: token[:secureKey], format: :json }

      assert_response :created

      value = JSON.parse(response.body)
      assert_equal value["code"], 201
    end

    test "should destroy playlist" do
      token = giveToken() # because of security access
      assert_difference('Playlist.count', -1) do
        get :destroy, { id: @playlist, user_id: token[:id], secureKey: token[:secureKey], format: :json }
      end
      assert_response :ok
      value = JSON.parse(response.body)
      assert_equal value["code"], 202

      value = JSON.parse(response.body)
      assert_equal value["code"], 202
    end
  end
end