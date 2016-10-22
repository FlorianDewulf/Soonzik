require 'test_helper'

module API
  class ApisecurityControllerTest < ActionController::TestCase
    setup do
      @user = users(:UserOne)
    end

    test "should provide key" do
      get :provideKey, id: @user.id, format: :json
      assert_response :success

      value = JSON.parse(response.body)
      assert_equal value["key"], @user.idAPI
    end

    test "login FB" do
      get :loginFB, email: "toto@email.fr", token: "azerty", format: :json
      assert_response :not_found

      value = JSON.parse(response.body)
      assert_equal value["code"], 502
    end
  end
end