class OthersController < ApplicationController
  include FormatsHelper
	before_action :no_content, except: [:discotheque, :soundcloud]

	def no_content
		render :text => "", :layout => true
	end

	def index
	end

	def search
	end

	def explorer
	end

	def discotheque
		if (!user_signed_in?)
			flash[:notice] = "You need to be login to access to this page"
			redirect_to :root
		else
			render :text => "", :layout => true
		end
	end

	def soundcloud
		render 'public/callback.html'
	end
end