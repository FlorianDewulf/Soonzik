require 'test_helper'

module API
  class MusicsControllerTest < ActionController::TestCase
    def giveToken
      return { id: @user.id, secureKey: @user.secureKey }
    end
    
    setup do
      @user = users(:UserOne)
      @music = musics(:MusicOne)
    end

    test "should get index" do
      get :index, format: :json
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
    end

    test "should show music ok" do
      get :show, { id: @music, format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"]["id"], @music.id
    end

    test "should show music ko" do
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


      get :find, { limit: 1, offset: 0, attribute: { title: "%tit%" }, order_by_asc: ["price"], order_by_desc: ["album_id"], group_by: ["id"], format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"].size, 1
    end

    test "should add comment" do
      token = giveToken() # because of security access
      post :addcomment, { id: @music, content: "ceci est un commentaire", user_id: token[:id], secureKey: token[:secureKey], format: :json }
      assert_response :created
    end

    test "should return the music" do
      get :get, { id: @music, format: "mp3" }
      assert_response :success
    end

    test "should add to playlist" do
      token = giveToken() # because of security access
      playlist = playlists(:PlaylistOne)
      post :addtoplaylist, { id: @music.id, playlist_id: playlist.id, user_id: token[:id], secureKey: token[:secureKey], format: :json }
      assert_response :created
    end
  end
end