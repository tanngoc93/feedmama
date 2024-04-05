class BlockedCommentator < ApplicationRecord
  belongs_to :social_account

  after_create :destroy_blocked_commentator_job

  def destroy_blocked_commentator_job
    DestroyBlockedCommentatorJob.perform_at(social_account.time_blocking.hours.from_now, id)
  end
end
