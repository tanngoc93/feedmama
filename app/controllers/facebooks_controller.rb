class FacebooksController < ApplicationController
  skip_before_action :authenticate_user!, only: [:subscription]
  skip_before_action :verify_authenticity_token, only: [:subscription]

  before_action :find_app_setting, only: [:subscription]
  before_action :find_social_account, only: [:subscription]
  before_action :find_user_setting, only: [:subscription]

  def subscription
    return unless @app_setting.present?

    if(realtime_request?(request))
      case request.method
      when 'GET'
        challenge = Koala::Facebook::RealtimeUpdates.meet_challenge(params, @app_setting&.verify_token)

        if(challenge)
          render :plain => challenge
        else
          render :plain => 'Failed to authorize facebook challenge request'
        end
      when 'POST'
        data = params['entry'][0]['changes'][0]['value']

        return unless @social_account.present?
        return unless @user_setting.present?
        
        facebook_comment(data) if @social_account.facebook?
        instagram_comment(data) if @social_account.instagram?

        render :plain => 'Thanks for the update.'
      end
    end
  rescue StandardError => e
  end

  private

  def realtime_request?(request)
    ((request.method == 'GET' && params['hub.mode'].present?) ||
       (request.method == 'POST' && request.headers['X-Hub-Signature'].present?))
  end

  def find_app_setting
    @app_setting =
      AppSetting.where(secured_token: params[:secured_token], status: true)&.first
  end

  def find_social_account
    return unless request.method == 'POST'

    @social_account =
      SocialAccount.where(resource_id: params['entry'][0]['id'], status: true)&.first
  end

  def find_user_setting
    return unless @social_account.present?

    @user_setting =
      UserSetting.where(user_id: @social_account.user_id, setting_status: :active)&.first
  end

  def facebook_comment(data)
    post_id = data['post_id']
    comment = data['message']
    comment_id = data['comment_id']
    commentator_id = data['from']['id']
    commentator_name = data['from']['name']

    return if comment.nil? || commentator_id == @social_account&.resource_id
    return if blocked_commentator(commentator_id, @social_account.id).present?

    if add_comment?(data)
      FbReplyCommentJob.perform_at(
        @social_account.perform_at.seconds.from_now,
        post_id,
        comment_id,
        comment,
        commentator_name,
        @social_account.id,
        @user_setting.id
      )

      create_blocked_commentator(commentator_id, @social_account.id, post_id)
    end
  end

  def instagram_comment(data)
    media_id = data['media']['id']
    comment = data['text']
    comment_id = data['id']
    commentator_id = data['from']['id']
    commentator_name   = data['from']['username']

    return if comment.nil? || commentator_id == @social_account&.resource_id
    return if blocked_commentator(commentator_id, @social_account.id).present?

    InsReplyCommentJob.perform_at(
      @social_account.perform_at.seconds.from_now,
      media_id,
      comment_id,
      comment,
      commentator_name,
      @social_account.id,
      @user_setting.id
    )

    create_blocked_commentator(commentator_id, @social_account.id, media_id)
  end

  def create_blocked_commentator(commentator_id, social_account_id, post_id)
    blocked_commentator = BlockedCommentator.find_or_create_by(
      commentator_id: commentator_id,
      social_account_id: social_account_id
    )

    blocked_commentator&.update(post_id: media_id)
  end

  def blocked_commentator(commentator_id, social_account_id)
    @blocked_commentator ||= BlockedCommentator.where(commentator_id: commentator_id, social_account_id: social_account_id).first
  end

  def add_comment?(data)
    data['item'] == 'comment' && data['verb'] == 'add'
  end
end
