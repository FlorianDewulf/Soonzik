require 'test_helper'

class AccessesControllerTest < ActionController::TestCase
  setup do
    @access = accesses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:accesses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create access" do
    assert_difference('Access.count') do
      post :create, access: { actionName: @access.actionName, controllerName: @access.controllerName, group_id: @access.group_id }
    end

    assert_redirected_to access_path(assigns(:access))
  end

  test "should show access" do
    get :show, id: @access
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @access
    assert_response :success
  end

  test "should update access" do
    patch :update, id: @access, access: { actionName: @access.actionName, controllerName: @access.controllerName, group_id: @access.group_id }
    assert_redirected_to access_path(assigns(:access))
  end

  test "should destroy access" do
    assert_difference('Access.count', -1) do
      delete :destroy, id: @access
    end

    assert_redirected_to accesses_path
  end
end
