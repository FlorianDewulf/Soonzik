# The mailer for the newsletter
class Newsletter < ActiveRecord::Base
	def send_to_all_user
		User.where(newsletter: true).all.each do |user|
			NewsletterMailer.newsletter_email(user.email, self.obj_msg, self.html_content)
		end
	end
end