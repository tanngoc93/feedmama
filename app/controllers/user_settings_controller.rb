class UserSettingsController < ApplicationController

  before_action :find_user_setting, only: [:update]

  def show
    @user_setting = UserSetting.find_or_create_by(user_id: current_user.id)
  end

  def update
    @user_setting = UserSetting.find_or_create_by(user_id: current_user.id)

    if @user_setting&.update!(user_setting_params)
      redirect_to root_path, notice: 'Your data was updated successfully'
    else
      render :show, notice: @user_setting&.errors&.full_messages&.to_sentence
    end
  end

  private

  def find_user_setting
    @user_setting = UserSetting.where(user_id: current_user.id)
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
