class FacebooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  PAGE_ID = ENV.fetch('PAGE_ID')
  VERIFY_TOKEN = ENV.fetch('VERIFY_TOKEN')
  SECURE_TOKEN = ENV.fetch('SECURE_TOKEN')

  def subscription
    return unless params[:secure_token] == SECURE_TOKEN

    if(realtime_request?(request))
      case request.method
      when "GET"
        challenge = Koala::Facebook::RealtimeUpdates.meet_challenge(params, VERIFY_TOKEN)

        if(challenge)
          render :plain => challenge
        else
          render :plain => 'Failed to authorize facebook challenge request'
        end
      when "POST"
        data = params['entry'][0]['changes'][0]['value']

        reply_service(data)

        render :plain => 'Thanks for the update.'
      end
    end
  rescue StandardError => e
    Rails.logger.debug(">>>>> #{e.message}")
  end

  private

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
    commentator_id = data['from']['id']
    commentator_name = data['from']['name']

    return if comment.nil? || comment_id.nil? || comment_id == PAGE_ID

    if new_comment?(data)
      blocker = Blocker.where(post_id: post_id, commenter_id: comment_id).last

      Rails.logger.debug('>>>>> REPLY')

      ReplyCommentJob.perform_at(1.minutes.from_now, post_id, comment_id, comment, commentator_name)
    else
      Rails.logger.debug('>>>>> SKIP')
    end
  end
end
