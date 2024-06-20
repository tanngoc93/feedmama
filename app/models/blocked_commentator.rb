class BlockedCommentator < ApplicationRecord
  belongs_to :social_account

  after_create :set_destroy_blocked_commenter_job

  def set_destroy_blocked_commenter_job
    DestroyBlockedCommenterJob.perform_at(social_account.time_blocking.hours.from_now, id)
  end
end
