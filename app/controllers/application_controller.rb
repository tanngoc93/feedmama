class ApplicationController < ActionController::Base
  FB_VERSION = ENV.fetch("FB_VERSION") {"v16.0"}

  before_action :authenticate_user!
end
