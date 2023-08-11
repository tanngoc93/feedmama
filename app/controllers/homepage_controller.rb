class HomepageController < ApplicationController
  def index
    @social_accounts = current_user.social_accounts.all
  end
end
