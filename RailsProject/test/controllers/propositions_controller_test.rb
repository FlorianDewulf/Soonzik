require 'test_helper'

class PropositionsControllerTest < ActionController::TestCase
  setup do
    @proposition = propositions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:propositions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create proposition" do
    assert_difference('Proposition.count') do
      post :create, proposition: { album_id: @proposition.album_id, artist_id: @proposition.artist_id, date_posted: @proposition.date_posted, state: @proposition.state }
    end

    assert_redirected_to proposition_path(assigns(:proposition))
  end

  test "should show proposition" do
    get :show, id: @proposition
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @proposition
    assert_response :success
  end

  test "should update proposition" do
    patch :update, id: @proposition, proposition: { album_id: @proposition.album_id, artist_id: @proposition.artist_id, date_posted: @proposition.date_posted, state: @proposition.state }
    assert_redirected_to proposition_path(assigns(:proposition))
  end

  test "should destroy proposition" do
    assert_difference('Proposition.count', -1) do
      delete :destroy, id: @proposition
    end

    assert_redirected_to propositions_path
  end
end
