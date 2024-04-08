module ApplicationHelper
  def set_number_to_delimited(value, delimiter: ',')
    ActiveSupport::NumberHelper.number_to_delimited(value, delimiter: delimiter)
  end

  def user_setting_types
    UserSetting.setting_types.map {|k, v| [k.humanize.titleize, k]}
  end

  def user_setting_api_providers
    UserSetting.api_providers.map {|k, v| [k.humanize.titleize, k]}
  end
end
