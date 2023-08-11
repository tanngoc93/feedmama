class SocialAccountsController < ApplicationController
  def facebook_oauth_code
    @oauth = Koala::Facebook::OAuth.new(
      Koala.config.app_id,
      Koala.config.app_secret,
      callback_url
    )

    setting = AppSetting.where(status: true).first

    redirect_to @oauth.url_for_oauth_code(permissions: setting.facebook_permissions), allow_other_host: true
  end

  def facebook_oauth_callback
    request = get_facebook_access_token( params[:code] )

    if request.status == 200
      pages = get_facebook_pages( JSON.parse(request.body)["access_token"] )

      pages.each do |page|
        account = current_user.social_accounts.find_or_create_by(
          resource_id: page["id"],
          resource_name: page["name"],
          resource_platform: "facebook"
        )

        set_subscribed_fields(page["id"], page["access_token"])

        account&.update(resource_access_token: page["access_token"])
      end

      redirect_to root_path, notice: "Successfully"
    else
      error = request.status == 400 ? JSON.parse(request.body)["error"] : nil

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
    pages = koala.get_connections("me", "accounts")
    pages
  end

  def get_facebook_access_token(code)
    conn = Faraday.new(
      url: "https://graph.facebook.com/#{ FB_VERSION }/oauth/access_token?redirect_uri=#{ callback_url }&client_id=#{ Koala.config.app_id }&client_secret=#{ Koala.config.app_secret }&code=#{ code }",
      headers: {
        "Content-Type": "application/json"
      }
    )

    conn.get
  end

  def set_subscribed_fields(page_id, access_token)
    conn = Faraday.new(
      url: "https://graph.facebook.com/#{ FB_VERSION }/#{ page_id }/subscribed_apps?subscribed_fields=feed&access_token=#{ access_token }",
      headers: {
        "Content-Type": "application/json"
      }
    )

    conn.post
  end
end
