class SocialAccount < ApplicationRecord
  has_many :auto_comments
  has_one :social_account, class_name: 'SocialAccount', foreign_key: 'parent_social_account_id'
  belongs_to :parent_social_account, class_name: 'SocialAccount', foreign_key: 'parent_social_account_id', optional: true

  enum resource_platform: {
    facebook: 'facebook',
    instagram: 'instagram',
  }

  after_save :refresh_access_token

  private

  def refresh_access_token
    if facebook? && saved_change_to_resource_access_token?
      remove_scheduled && RefreshAccessTokenJob.perform_at(45.days.from_now, id)
    end
  end

  def remove_scheduled
    scheduled_set = Sidekiq::ScheduledSet.new
    scheduled_set.select do |scheduled|
      scheduled.klass == 'RefreshAccessTokenJob' && scheduled.args[0] == id
    end.map(&:delete)
  end
end
