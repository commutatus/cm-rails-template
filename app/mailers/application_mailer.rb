class ApplicationMailer < ActionMailer::Base
  default from: 'info@domain.com'
  layout 'mailer'

	@@postmark_key = Rails.application.credentials.postmark[:api_key]
	@@postmark_client = Postmark::ApiClient.new(@@postmark_key)

	def postmark_client

	end

end
