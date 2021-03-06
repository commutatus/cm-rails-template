class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :api_keys

  def find_or_generate_api_key
    self.live_api_key ? self.live_api_key : self.generate_api_key
  end

  def live_api_key
    api_keys.live.last
  end

  def generate_api_key
    api_keys.live.each { |api_key| api_key.expire }
    api_keys.create
  end

  def forgot_password_url(raw_token)
    forgot_password_url = URI::HTTPS.build(Rails.application.config.client_url.merge!({ path: '/auth/reset-password', query: "reset_token=#{raw_token}"} ))
    forgot_password_url.to_s
  end

end
