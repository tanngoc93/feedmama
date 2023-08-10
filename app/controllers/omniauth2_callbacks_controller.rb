class Omniauth2CallbacksController < ApplicationController
  def oauth
    @oauth= Koala::Facebook::OAuth.new(ENV['KOALA_APP_ID'], ENV['KOALA_APP_SECRET'], "#{request.base_url}/oauth_callback")
  
    permissions = 'pages_manage_engagement,pages_manage_metadata,pages_manage_posts,pages_read_engagement,pages_read_user_content'

    redirect_to @oauth.url_for_oauth_code(permissions: permissions), allow_other_host: true
  end

  def oauth_callback
    redirect_to "https://graph.facebook.com/v17.0/oauth/access_token?client_id=#{ENV['KOALA_APP_ID']}&redirect_uri=https://5e0e-116-100-44-186.ngrok-free.app/oauth_callback&client_secret=#{ENV['KOALA_APP_SECRET']}&code=#{params[:code]}", allow_other_host: true
  end
end

