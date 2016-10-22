require 'test_helper'

class AlbumNotesControllerTest < ActionController::TestCase
  setup do
    @album_note = album_notes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:album_notes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create album_note" do
    assert_difference('AlbumNote.count') do
      post :create, album_note: { album_id: @album_note.album_id, user_id: @album_note.user_id, value: @album_note.value }
    end

    assert_redirected_to album_note_path(assigns(:album_note))
  end

  test "should show album_note" do
    get :show, id: @album_note
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @album_note
    assert_response :success
  end

  test "should update album_note" do
    patch :update, id: @album_note, album_note: { album_id: @album_note.album_id, user_id: @album_note.user_id, value: @album_note.value }
    assert_redirected_to album_note_path(assigns(:album_note))
  end

  test "should destroy album_note" do
    assert_difference('AlbumNote.count', -1) do
      delete :destroy, id: @album_note
    end

    assert_redirected_to album_notes_path
  end
end
