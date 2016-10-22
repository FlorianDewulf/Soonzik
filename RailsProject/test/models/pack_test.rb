require 'test_helper'

class PackTest < ActiveSupport::TestCase
  test 'self params' do
  	#just because nothing use it for the moment
  	params = ActionController::Parameters.new({pack: {title: "test", style: "rock"}})
  	p = Pack.new(Pack.pack_params(params))
  	assert_not_nil p
  end
end
