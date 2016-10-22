require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { activated: @user.activated, adress_id: @user.adress_id, birthday: @user.birthday, description: @user.description, email: @user.email, facebook: @user.facebook, fname: @user.fname, googlePlus: @user.googlePlus, idAPI: @user.idAPI, image: @user.image, language: @user.language, lname: @user.lname, newsletter: @user.newsletter, password: @user.password, phoneNumber: @user.phoneNumber, salt: @user.salt, secureKey: @user.secureKey, signin: @user.signin, twitter: @user.twitter, username: @user.username }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    patch :update, id: @user, user: { activated: @user.activated, adress_id: @user.adress_id, birthday: @user.birthday, description: @user.description, email: @user.email, facebook: @user.facebook, fname: @user.fname, googlePlus: @user.googlePlus, idAPI: @user.idAPI, image: @user.image, language: @user.language, lname: @user.lname, newsletter: @user.newsletter, password: @user.password, phoneNumber: @user.phoneNumber, salt: @user.salt, secureKey: @user.secureKey, signin: @user.signin, twitter: @user.twitter, username: @user.username }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
end
