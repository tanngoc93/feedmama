class AppSetting < ApplicationRecord
  before_create :generate_tokens

  validate :only_one_setting_can_be_active_at_once

  enum :api_provider, %i[openai_service azure_openai_service]

  private

  def only_one_setting_can_be_active_at_once
    return unless self.status

    if self.class.where(status: true).where.not(id: id).any?
      self.errors.add(:base, "Sorry, please ensure that only one setting can be active at once. Please disable the currently active setting first, then you can enable this one.")
    end
  end

  def generate_tokens
    self.verify_token = generate_verify_token
    self.secured_token = generate_secured_token
  end

  def generate_verify_token
    loop do
      token = rand(10 ** 12)
      break token unless AppSetting.where(verify_token: token).exists?
    end
  end

  def generate_secured_token
    loop do
      token = SecureRandom.hex(16)
      break token unless AppSetting.where(secured_token: token).exists?
    end
  end
end
