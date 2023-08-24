class ApplicationController < ActionController::Base
  FACEBOOK_VERSION = ENV.fetch("FACEBOOK_VERSION") { "v16.0" }

  protect_from_forgery with: :null_session

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end
end
