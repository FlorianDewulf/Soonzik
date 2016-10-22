class ConcertsController < ApplicationController
	before_action :no_content

	def no_content
		render :text => "", :layout => true
	end

	def index
	end

	def show
	end
end
