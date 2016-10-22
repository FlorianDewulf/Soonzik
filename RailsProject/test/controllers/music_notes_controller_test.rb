require 'test_helper'

class MusicNotesControllerTest < ActionController::TestCase
  setup do
    @music_note = music_notes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:music_notes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create music_note" do
    assert_difference('MusicNote.count') do
      post :create, music_note: { album_id: @music_note.album_id, user_id: @music_note.user_id, value: @music_note.value }
    end

    assert_redirected_to music_note_path(assigns(:music_note))
  end

  test "should show music_note" do
    get :show, id: @music_note
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @music_note
    assert_response :success
  end

  test "should update music_note" do
    patch :update, id: @music_note, music_note: { album_id: @music_note.album_id, user_id: @music_note.user_id, value: @music_note.value }
    assert_redirected_to music_note_path(assigns(:music_note))
  end

  test "should destroy music_note" do
    assert_difference('MusicNote.count', -1) do
      delete :destroy, id: @music_note
    end

    assert_redirected_to music_notes_path
  end
end
