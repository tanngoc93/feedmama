class HomepageController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if current_user
      @social_accounts = current_user.social_accounts.order(:resource_name)
    else
      []
    end
  end
end
