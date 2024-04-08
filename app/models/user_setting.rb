class UserSetting < ApplicationRecord
  belongs_to :user

  enum :setting_status, %i[active inactive]
  enum :setting_type, %i[self_service managed_service]
  enum :api_provider, %i[openai_service azure_openai_service]

  before_create :set_setting_type

  private

  def set_setting_type_and_provider
    self.setting_type = :self_service
    self.api_provider = :openai_service
    self
  end
end
