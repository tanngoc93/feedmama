class SocialAccountsController < ApplicationController
  before_action :find_social_account, only: [:show, :update, :destroy]

  def show; end

  def update
    if @social_account&.update(social_account_params)
      redirect_to root_path, notice: "Successfully updated"
    else
      render :show, notice: @social_account&.errors&.full_messages&.to_sentence
    end
  end

  def destroy
    if @social_account&.destroy
      redirect_to root_path, notice: "Successfully deleted"
    else
      render :show, notice: @social_account&.errors&.full_messages&.to_sentence
    end
  end

  def facebook_oauth_code
    @oauth = Koala::Facebook::OAuth.new(
      Koala.config.app_id,
      Koala.config.app_secret,
      callback_url
    )

    permissions = "public_profile,business_management,instagram_basic,pages_manage_metadata,pages_show_list,pages_messaging,pages_read_user_content,pages_manage_engagement,pages_read_engagement"

    redirect_to @oauth.url_for_oauth_code(permissions: permissions, options: { type: :facebook }), allow_other_host: true
  end
  def facebook_oauth_callback
    request = get_page_access_token( params[:code] )

    if request.status == 200
      pages = get_list_pages( JSON.parse(request.body)["access_token"] )
      pages&.each do |page|
        facebook = current_user.social_accounts.find_or_create_by(
          resource_id: page["id"],
          resource_name: page["name"],
          resource_platform: "facebook"
        )

        set_subscribed_fields(page["id"], page["access_token"])

        facebook&.update(resource_access_token: page["access_token"])

        request = get_instagram(page["id"], page["access_token"])

        instagrams = JSON.parse(request.body)["data"]
        instagrams&.each do |_instagram|
          instagram = current_user.social_accounts.find_or_create_by(
            resource_id: _instagram["id"],
            resource_name: _instagram["username"],
            parent_social_account_id: facebook.id,
            resource_platform: "instagram"
          )

          instagram&.update(resource_access_token: page["access_token"])
        end
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

  def find_social_account
    @social_account = SocialAccount.find_by(id: params[:id])
  end

  def social_account_params
    params.require(:social_account)
      .permit(
        :status,
        :use_openai,
        :openai_prompt,
        :use_openai_when_comment_is_longer_in_length,
        auto_comments_attributes: [:id, :content, :_destroy]
      )
  end

  def callback_url
    @callback_url ||= "#{ request.base_url }/social_accounts/facebook/callback".freeze
  end

  def get_list_pages(access_token)
    koala = Koala::Facebook::API.new(access_token)
    pages = koala.get_connections("me", "accounts")
    pages
  end

  def get_instagram(page_id, access_token)
    conn = Faraday.new(
      url: "https://graph.facebook.com/#{ FACEBOOK_VERSION }/#{page_id}/instagram_accounts?fields=id,username&access_token=#{access_token}",
      headers: {
        "Content-Type": "application/json"
      }
    )

    conn.get
  end

  def get_page_access_token(code)
    conn = Faraday.new(
      url: "https://graph.facebook.com/#{ FACEBOOK_VERSION }/oauth/access_token?redirect_uri=#{ callback_url }&client_id=#{ Koala.config.app_id }&client_secret=#{ Koala.config.app_secret }&code=#{ code }",
      headers: {
        "Content-Type": "application/json"
      }
    )

    conn.get
  end

  def set_subscribed_fields(page_id, access_token)
    conn = Faraday.new(
      url: "https://graph.facebook.com/#{ FACEBOOK_VERSION }/#{ page_id }/subscribed_apps?subscribed_fields=feed&access_token=#{ access_token }",
      headers: {
        "Content-Type": "application/json"
      }
    )

    conn.post
  end
end
