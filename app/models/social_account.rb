class SocialAccount < ApplicationRecord
  belongs_to :user

  has_one :social_account, class_name: "SocialAccount", foreign_key: "parent_social_account_id"
  belongs_to :parent_social_account, class_name: "SocialAccount", foreign_key: "parent_social_account_id", optional: true

  has_many :blockers, dependent: :destroy

  has_many :auto_comments, dependent: :destroy
  accepts_nested_attributes_for :auto_comments, allow_destroy: true

  enum resource_platform: {
    facebook: "facebook",
    instagram: "instagram",
  }

  private

  # not use at this time
  def refresh_access_token
    if facebook? && saved_change_to_resource_access_token?
      remove_scheduled && RefreshAccessTokenJob.perform_at(45.days.from_now, id)
    end
  end
 
  def remove_scheduled
    scheduled_set = Sidekiq::ScheduledSet.new
    scheduled_set.select do |scheduled|
      scheduled.klass == "RefreshAccessTokenJob" && scheduled.args[0] == id
    end.map(&:delete)
  end
end
