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
end
