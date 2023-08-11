class SocialAccountsController < ApplicationController
  def facebook_oauth_code
    @oauth= Koala::Facebook::OAuth.new(ENV['KOALA_APP_ID'], ENV['KOALA_APP_SECRET'], callback_url)

    permissions = 'public_profile,pages_show_list,pages_manage_engagement,pages_read_engagement,pages_manage_metadata,pages_manage_posts,pages_read_user_content'

    redirect_to @oauth.url_for_oauth_code(permissions: permissions), allow_other_host: true
  end

  def facebook_oauth_callback
    request = get_facebook_access_token( params[:code] )

    if request.status == 200
      pages = get_facebook_pages( JSON.parse(request.body)['access_token'] )

      Rails.logger.debug(">>>>>> AccessToken = #{JSON.parse(request.body)['access_token']}")

      pages.each do |page|
        account = current_user.social_accounts.find_or_create_by(
          resource_id: page['id'],
          resource_name: page['name'],
          resource_platform: 'facebook'
        )

        account&.update(resource_access_token: page['access_token'])
      end

      redirect_to root_path, notice: 'Successfully'
    else
      error = request.status == 400 ? JSON.parse(request.body)['error'] : nil

      render json: {
        status: request.status,
        error: error
      }
    end
  end

  private

  def callback_url
     @callback_url ||= "#{ request.base_url }/social_accounts/facebook/callback".freeze
  end

  def get_facebook_pages(access_token)
    koala = Koala::Facebook::API.new(access_token)
    pages = koala.get_connections('me', 'accounts')
    pages
  end

  def get_facebook_access_token(code)
    conn = Faraday.new(
      url: "https://graph.facebook.com/v17.0/oauth/access_token?redirect_uri=#{ callback_url }&client_id=#{ ENV['KOALA_APP_ID'] }&client_secret=#{ ENV['KOALA_APP_SECRET'] }&code=#{ code }",
      headers: {
        'Content-Type': 'application/json'
      }
    )

    conn.get
  end
end
