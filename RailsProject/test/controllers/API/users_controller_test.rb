require 'test_helper'

module API
  class UsersControllerTest < ActionController::TestCase
    def giveToken
      return { id: @user.id, secureKey: @user.secureKey }
    end
    
    setup do
      @user = users(:UserOne)
    end

    test "should get index" do
      get :index, format: :json
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
    end

    test "should save user" do
      token = giveToken() # because of security access
      post :save, { user: { address_id: @user.address.id, birthday: @user.birthday, description: "nouvelle description", email: "test@mail.ru", facebook: @user.facebook, fname: @user.fname, googlePlus: @user.googlePlus, image: @user.image, language: @user.language, lname: @user.lname, newsletter: true, password: @user.encrypted_password, phoneNumber: @user.phoneNumber, twitter: @user.twitter, username: "new test username" }, user_id: token[:id], secureKey: token[:secureKey], format: :json }
      assert_response :created

      value = JSON.parse(response.body)
      assert_equal value["code"], 201
    end

    test "should show user ok" do
      get :show, { id: @user, format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"]["id"], @user.id
    end

    test "should show user ko" do
      get :show, { id: 12345, format: :json }
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


      get :find, { limit: 1, offset: 0, attribute: { username: "%test%", fname: "first name" }, order_by_asc: ["lname"], order_by_desc: ["description"], group_by: ["twitter"], format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
      assert_equal value["content"].size, 1
    end

    test "should update user" do
      token = giveToken() # because of security access
      post :update, { id: @user.id, address: { numberStreet: 2 }, user: { address_id: @user.address_id, birthday: @user.birthday, description: "deuxieme description", email: @user.email, facebook: @user.facebook, fname: @user.fname, googlePlus: @user.googlePlus, idAPI: @user.idAPI, image: @user.image, language: @user.language, lname: @user.lname, newsletter: @user.newsletter, password: @user.encrypted_password, phoneNumber: @user.phoneNumber, salt: @user.salt, secureKey: @user.secureKey, twitter: @user.twitter, username: @user.username }, user_id: token[:id], secureKey: token[:secureKey], format: :json }

      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 201
    end

    test "should get musics of user" do
      #Because I can't associate purchase to other item directly and ids of purchase items are randomize so I need to associate the good one here
      music = musics(:MusicOne)
      album = albums(:AlbumOne)
      pack = packs(:PackOne)

      purchase = purchases(:PurchaseTwo)
      purchase.addPurchasedMusicFromObject(music)
      purchase.save

      #---
      purchase_album = Purchase.new
      purchase_album.user_id = @user.id
      purchase_album.save
      purchase_album.addPurchasedAlbumFromObject(album)

      #--
      purchase_pack = Purchase.new
      purchase_pack.user_id = @user.id
      purchase_pack.save
      purchase_pack.addPurchasedPackFromObject(pack, true)


      token = giveToken() # because of security access
      get :getmusics, { user_id: token[:id], secureKey: token[:secureKey], format: :json }
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["code"], 200
    end
  end
end