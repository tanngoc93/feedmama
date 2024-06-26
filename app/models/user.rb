class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :confirmable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: []

  has_many :social_accounts, dependent: :destroy
  has_many :orders, dependent: :destroy

  has_one  :user_setting, dependent: :destroy
  has_one  :token, dependent: :destroy

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.first_name = auth["info"]["name"]
      user.email = auth["info"]["email"] || "#{auth["provider"]}#{auth["uid"]}@#{auth["provider"]}.com"
      user.password = Devise.friendly_token[0,20]

      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      user.skip_confirmation!
    end
  end

  def token_amount
    self.token&.amount || 0
  end
end
