require 'test_helper'

class ListeningsControllerTest < ActionController::TestCase
  setup do
    @listening = listenings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:listenings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create listening" do
    assert_difference('Listening.count') do
      post :create, listening: { latitude: @listening.latitude, longitude: @listening.longitude, music_id: @listening.music_id, user_id: @listening.user_id, when: @listening.when }
    end

    assert_redirected_to listening_path(assigns(:listening))
  end

  test "should show listening" do
    get :show, id: @listening
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @listening
    assert_response :success
  end

  test "should update listening" do
    patch :update, id: @listening, listening: { latitude: @listening.latitude, longitude: @listening.longitude, music_id: @listening.music_id, user_id: @listening.user_id, when: @listening.when }
    assert_redirected_to listening_path(assigns(:listening))
  end

  test "should destroy listening" do
    assert_difference('Listening.count', -1) do
      delete :destroy, id: @listening
    end

    assert_redirected_to listenings_path
  end
end
