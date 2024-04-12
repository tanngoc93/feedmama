class UserSettingsController < ApplicationController

  before_action :find_user_setting, only: [:show, :update]

  def show; end

  def update
    if @user_setting&.update(user_setting_params)
      redirect_to root_path, notice: 'Your data has been updated successfully'
    else
      redirect_to :user_settings, alert: @user_setting&.errors&.full_messages&.to_sentence
    end
  end

  private

  def find_user_setting
    @user_setting = UserSetting.find_or_create_by(user_id: current_user.id)
  end

  def user_setting_params
    params.require(:user_setting)
      .permit(
        :setting_status,
        :setting_type,
        :api_model,
        :api_provider,
        :api_endpoint,
        :api_version,
        :api_access_token,
      )
  end
end
