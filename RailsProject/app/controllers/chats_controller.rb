class ChatsController < ApplicationController
  include FormatsHelper

  def index
  	if !user_signed_in?
  		redirect_to root_path, notice: 'You need to be connected to access to this page'
  	end
  end
end