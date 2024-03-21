class PagesController < ApplicationController
  def privacy_policy
    render "/pages/privacy_policy"
  end

  def terms_of_service
    render "/pages/terms_of_service"
  end
end
