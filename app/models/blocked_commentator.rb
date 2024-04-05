class BlockedCommentator < ApplicationRecord
  belongs_to :social_account

  after_create :destroy_blocked_commentator_job

  def destroy_blocked_commentator_job
    DestroyBlockedCommentatorJob.perform_at(6.hours.from_now, id)
  end
end
