require 'test_helper'

class FlacTest < ActiveSupport::TestCase
  test 'self params' do
  	#just because nothing use it for the moment
  	params = ActionController::Parameters.new({flac: {file: "test"}})
  	f = Flac.new(Flac.flac_params(params))
  	assert_not_nil f
  end
end
