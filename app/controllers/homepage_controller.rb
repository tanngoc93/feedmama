class HomepageController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @social_accounts = current_user&.social_accounts || []
  end
end
