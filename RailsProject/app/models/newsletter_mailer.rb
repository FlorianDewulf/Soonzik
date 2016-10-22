class NewsletterMailer < ActionMailer::Base
	default from: "no-reply@soonzik.com"

  def newsletter_email(email, subject, content)
    mail(to: email, subject: subject, body: content, content_type: "text/html").deliver
  end
end