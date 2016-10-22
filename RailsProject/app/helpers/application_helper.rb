module ApplicationHelper

	def socialIconConnect(provider)
 		case provider
   			when "facebook"
     			return "<i class='step fi-social-facebook size-42'></i>"
   			when "twitter"
   				return "<i class='step fi-social-twitter size-42'></i>"
   			when "google"
   				return "<i class='step fi-social-google-plus size-42'></i>"
   			else
   				return "<span>#{provider}</span>"
 		end
	end
end
