class FacebooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :find_social_account

  def subscription
    return unless @social_account.present?

    if(realtime_request?(request))
      case request.method
      when "GET"
        challenge = Koala::Facebook::RealtimeUpdates.meet_challenge(params, @social_account.verify_token)

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

  def find_social_account
    @social_account = SocialAccount.where(secured_token: params[:secured_token], active: true).first
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

    return if comment.nil? || commentator_id == @social_account.resource_id

    if new_comment?(data)
      blocker = Blocker.where(
        commentator_id: commentator_id,
        social_account_id: @social_account.id
      ).first

      return if blocker.present? && blocker.updated_at > 12.hours.ago

      ReplyCommentJob.perform_at(
        1.minutes.from_now,
        post_id,
        comment_id,
        comment,
        commentator_name,
        @social_account.id
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

# Sample Request Data
# 
# {"entry": 
#   [{"id": "105941988574577",
#     "time": 1683184742,
#     "changes": 
#      [{"value": 
#         {"from": {"id": "5569956876395939", "name": "Ngoc Nguyen Tan"},
#          "post": 
#           {"status_type": "added_video", "is_published": true, "updated_time": "2023-05-04T07:18:58+0000", "permalink_url": "https://www.facebook.com/reel/1386895098519603/", "promotion_status": "ineligible", "id": "105941988574577_256193050254443"},
#          "message": "Wow",
#          "post_id": "105941988574577_256193050254443",
#          "comment_id": "256193050254443_269788982140402",
#          "created_time": 1683184738,
#          "item": "comment",
#          "parent_id": "105941988574577_256193050254443",
#          "verb": "add"},
#        "field": "feed"}]}],
#  "object": "page",
#  "secure_token": "[FILTERED]",
#  "facebook": 
#   {"entry": 
#     [{"id": "105941988574577",
#       "time": 1683184742,
#       "changes": 
#        [{"value": 
#           {"from": {"id": "5569956876395939", "name": "Ngoc Nguyen Tan"},
#            "post": 
#             {"status_type": "added_video", "is_published": true, "updated_time": "2023-05-04T07:18:58+0000", "permalink_url": "https://www.facebook.com/reel/1386895098519603/", "promotion_status": "ineligible", "id": "105941988574577_256193050254443"},
#            "message": "Wow",
#            "post_id": "105941988574577_256193050254443",
#            "comment_id": "256193050254443_269788982140402",
#            "created_time": 1683184738,
#            "item": "comment",
#            "parent_id": "105941988574577_256193050254443",
#            "verb": "add"},
#          "field": "feed"}]}],
#    "object": "page"}}