class PacksController < ApplicationController
  before_action :no_content, only: [:index, :show]

  def no_content
    render :text => "", :layout => true
  end

	def index
	end

	def show
	end
end
