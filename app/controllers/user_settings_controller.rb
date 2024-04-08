class UserSettingsController < ApplicationController
  before_action :find_user_setting, only: [:edit, :update]

  def edit; end

  def update
    
  end

  private

  def find_user_setting
    @user_setting = current_user.user_setting
  end
end
