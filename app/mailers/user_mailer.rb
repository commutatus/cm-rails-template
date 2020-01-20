class UserMailer < ApplicationMailer
	def forgot_password_email(user, url)
		@@postmark_client.deliver_with_template(from: 'info@domain.com',
																							to: user.email,
																							template_alias: "forgot-password",
																							template_model:{
																								email: user.email,
																								url: url
																							})
	end

	def confirmation_email(user, action_url)
		@@postmark_client.deliver_with_template(from: 'info@domain.com',
																							to: user.email,
																							template_alias: "email_verification",
																							template_model: {
																								first_name: user.first_name,
																								action_url: action_url,
																								email: user.email
																							})
	end

end
