class FacebooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :find_app_setting
  before_action :find_social_account

  def subscription
    return unless @app_setting.present?

    if(realtime_request?(request))
      case request.method
      when "GET"
        challenge = Koala::Facebook::RealtimeUpdates.meet_challenge(params, @app_setting.verify_token)

        if(challenge)
          render :plain => challenge
        else
          render :plain => 'Failed to authorize facebook challenge request'
        end
      when "POST"
        data = params['entry'][0]['changes'][0]['value']

        if @social_account.present?
          reply_service(data)
        else
          Rails.logger.debug(">>>>> SocialAccount was not found.")
        end

        render :plain => 'Thanks for the update.'
      end
    end
  rescue StandardError => e
    Rails.logger.debug(">>>>> #{e.message}")
  end

  private

  def find_app_setting
    @app_setting = AppSetting.where(secured_token: params[:secured_token], status: true).first
  end

  def find_social_account
    return if request.method != 'POST'

    resource_id = params['entry'][0]['id']

    @social_account = SocialAccount.where(resource_id: resource_id, status: true).first
  end

  def realtime_request?(request)
    ((request.method == "GET" && params['hub.mode'].present?) ||
       (request.method == "POST" && request.headers['X-Hub-Signature'].present?))
  end

  def new_comment?(data)
    data['item'] == 'comment' && data['verb'] == 'add'
  end

  def reply_service(data)
    post_id = data['post_id']
    comment = data['message']
    comment_id = data['comment_id']
    commentator_id = data['from']['id']
    commentator_name = data['from']['name']

    return if comment.nil? || commentator_id == @social_account&.resource_id

    if new_comment?(data)
      blocker = Blocker.where(
        commentator_id: commentator_id,
        social_account_id: @social_account.id
      ).first

      return if blocker.present? && blocker.updated_at > 12.hours.ago

      ReplyCommentJob.perform_at(
        3.minutes.from_now,
        post_id,
        comment_id,
        comment,
        commentator_name,
        @social_account.id,
        @app_setting.id
      )

      blocker = Blocker.find_or_create_by(
        commentator_id: commentator_id,
        social_account_id: @social_account.id
      )

      blocker.update(post_id: post_id)
    else
      Rails.logger.debug('>>>>> SKIP')
    end
  end
end
