require 'test_helper'

class FlacsControllerTest < ActionController::TestCase
  setup do
    @flac = flacs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:flacs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create flac" do
    assert_difference('Flac.count') do
      post :create, flac: { file: @flac.file, music_id: @flac.music_id }
    end

    assert_redirected_to flac_path(assigns(:flac))
  end

  test "should show flac" do
    get :show, id: @flac
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @flac
    assert_response :success
  end

  test "should update flac" do
    patch :update, id: @flac, flac: { file: @flac.file, music_id: @flac.music_id }
    assert_redirected_to flac_path(assigns(:flac))
  end

  test "should destroy flac" do
    assert_difference('Flac.count', -1) do
      delete :destroy, id: @flac
    end

    assert_redirected_to flacs_path
  end
end
