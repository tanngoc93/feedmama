class Blocker < ApplicationRecord
  belongs_to :social_account

  after_create :destroy_blocker_schedule

  def destroy_blocker_schedule
    DestroyBlockerJob.perform_at(6.hours.from_now, id)
  end
end
