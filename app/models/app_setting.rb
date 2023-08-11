class AppSetting < ApplicationRecord
  before_create :generate_tokens

  validate :cannot_active_more_than_one_setting

  private

  def cannot_active_more_than_one_setting
    return unless self.status

    if self.class.where(status: true).where.not(id: id).any?
      self.errors.add(:base, "In order to prevent conflicts, please ensure that only one setting is active at a time. Kindly deactivate any currently active settings before enabling a new one.")
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
