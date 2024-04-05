class SocialAccountsController < ApplicationController
  before_action :find_social_account, only: [:show, :update, :destroy]

  def show; end

  def update
    if @social_account&.update(social_account_params)
      redirect_to root_path, notice: 'Updated successfully'
    else
      render :show, notice: @social_account&.errors&.full_messages&.to_sentence
    end
  end

  def destroy
    if @social_account&.destroy
      redirect_to root_path, notice: 'Updated successfully'
    else
      render :show, notice: @social_account&.errors&.full_messages&.to_sentence
    end
  end

  def facebook_oauth
    @oauth = Koala::Facebook::OAuth.new(Koala.config.app_id, Koala.config.app_secret, callback_url('facebook'))

    permissions = 'public_profile,business_management,pages_manage_metadata,pages_show_list,pages_messaging,pages_read_user_content,pages_manage_engagement,pages_read_engagement'

    redirect_to @oauth.url_for_oauth_code(
      permissions: permissions,
      options: {
        type: :facebook
      }),
    allow_other_host: true
  end

  def facebook_oauth_callback
    request = oauth_access_token( params[:code], 'facebook' )

    if request.status == 200
      pages = list_facebook_pages( JSON.parse(request.body)['access_token'] )
      pages&.each do |page|
        social_account =
          current_user.social_accounts.find_or_create_by(
            resource_id: page['id'],
            resource_name: page['name'],
            resource_platform: :facebook
          )

        social_account&.update(resource_access_token: page['access_token'])
      end
    end

    redirect_to root_path, notice: 'Updated successfully'
  end

  def instagram_oauth
    @oauth = Koala::Facebook::OAuth.new(Koala.config.app_id, Koala.config.app_secret, callback_url('instagram'))

    permissions = 'public_profile,business_management,instagram_basic,instagram_manage_comments,pages_manage_metadata,pages_show_list,pages_messaging,pages_read_user_content,pages_manage_engagement,pages_read_engagement'

    redirect_to @oauth.url_for_oauth_code(
      permissions: permissions,
      options: {
        type: :facebook
      }),
    allow_other_host: true
  end

  def instagram_oauth_callback
    request = oauth_access_token( params[:code], 'instagram' )

    if request.status == 200
      pages = list_facebook_pages( JSON.parse(request.body)['access_token'] )

      pages&.each do |page|
        next unless page['connected_instagram_account'].present?

        request = instagram_api(page['connected_instagram_account']['id'], page['access_token'])
        response = JSON.parse(request.body)

        social_account = current_user.social_accounts.find_or_create_by(
          resource_id: response['id'],
          resource_name: response['name'],
          resource_username: response['username'],
          resource_platform: :instagram
        )

        social_account&.update(resource_access_token: page['access_token'])
      end
    end

    redirect_to root_path, notice: 'Updated successfully'
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

  def callback_url(prefix)
    "#{ request.base_url }/social_accounts/#{ prefix }/callback".freeze
  end

  def list_facebook_pages(access_token)
    koala = Koala::Facebook::API.new(access_token)
    pages = koala.get_connections('me', 'accounts?fields=id,name,access_token,connected_instagram_account,instagram_business_account,website')
    pages
  end

  def instagram_api(id, access_token)
    connect = Faraday.new(
      url: "https://graph.facebook.com/#{ FACEBOOK_VERSION }/#{id}?fields=id,name,username&access_token=#{access_token}",
      headers: headers
    )

    connect.get
  end

  def oauth_access_token(code, prefix)
    connect = Faraday.new(
      url: "https://graph.facebook.com/#{ FACEBOOK_VERSION }/oauth/access_token?redirect_uri=#{ callback_url(prefix) }&client_id=#{ Koala.config.app_id }&client_secret=#{ Koala.config.app_secret }&code=#{ code }",
      headers: headers
    )

    connect.get
  end

  def headers
    {
      'Content-Type': 'application/json'
    }
  end
end
