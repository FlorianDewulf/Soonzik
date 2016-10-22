module UsersHelper
	# Helper function to get an empty string for email and not the regex tmp
	def self.validate_email_for_oauth(current_user)
		if (!current_user.email_verified?)
			return ""
		end
		return current_user.email
	end

	# Helper function to get an empty string for username and not the regex tmp
	def self.validate_username_for_oauth(current_user)
		if (!current_user.username_verified?)
			return ""
		end
		return current_user.username
	end
end
