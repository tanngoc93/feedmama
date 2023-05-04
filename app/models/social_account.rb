class SocialAccount < ApplicationRecord
  enum resource_platform: {
    facebook: 'facebook',
    instagram: 'instagram',
  }

  before_create :generate_tokens

  private

  def generate_tokens
    self.verify_token = generate_verify_token
    self.secured_token = generate_secured_token
  end

  def generate_verify_token
    loop do
      token = Devise.friendly_token.upcase
      break token unless SocialAccount.where(verify_token: token).exists?
    end
  end

  def generate_secured_token
    loop do
      token = Devise.friendly_token
      break token unless SocialAccount.where(secured_token: token).exists?
    end
  end
end
