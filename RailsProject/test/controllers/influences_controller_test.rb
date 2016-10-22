require 'test_helper'

class InfluencesControllerTest < ActionController::TestCase
  setup do
    @influence = influences(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:influences)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create influence" do
    assert_difference('Influence.count') do
      post :create, influence: { name: @influence.name }
    end

    assert_redirected_to influence_path(assigns(:influence))
  end

  test "should show influence" do
    get :show, id: @influence
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @influence
    assert_response :success
  end

  test "should update influence" do
    patch :update, id: @influence, influence: { name: @influence.name }
    assert_redirected_to influence_path(assigns(:influence))
  end

  test "should destroy influence" do
    assert_difference('Influence.count', -1) do
      delete :destroy, id: @influence
    end

    assert_redirected_to influences_path
  end
end
