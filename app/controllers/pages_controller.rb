class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def pricing
    
  end

  def privacy_policy
    render '/pages/privacy_policy'
  end

  def terms_of_service
    render '/pages/terms_of_service'
  end
end
