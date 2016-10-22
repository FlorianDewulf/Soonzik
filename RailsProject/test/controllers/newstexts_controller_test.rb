require 'test_helper'

class NewstextsControllerTest < ActionController::TestCase
  setup do
    @newstext = newstexts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:newstexts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create newstext" do
    assert_difference('Newstext.count') do
      post :create, newstext: { content: @newstext.content, language: @newstext.language, news_id: @newstext.news_id, title: @newstext.title }
    end

    assert_redirected_to newstext_path(assigns(:newstext))
  end

  test "should show newstext" do
    get :show, id: @newstext
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @newstext
    assert_response :success
  end

  test "should update newstext" do
    patch :update, id: @newstext, newstext: { content: @newstext.content, language: @newstext.language, news_id: @newstext.news_id, title: @newstext.title }
    assert_redirected_to newstext_path(assigns(:newstext))
  end

  test "should destroy newstext" do
    assert_difference('Newstext.count', -1) do
      delete :destroy, id: @newstext
    end

    assert_redirected_to newstexts_path
  end
end
