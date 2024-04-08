class UserSetting < ApplicationRecord
  belongs_to :user

  enum :setting_status, %i[active inactive]
  enum :setting_type, %i[self_service managed_service]
  enum :api_provider, %i[openai_service azure_openai_service]
end
