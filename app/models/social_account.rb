class SocialAccount < ApplicationRecord
  belongs_to :user

  has_one :social_account, class_name: 'SocialAccount', foreign_key: 'parent_social_account_id'
  belongs_to :parent_social_account, class_name: 'SocialAccount', foreign_key: 'parent_social_account_id', optional: true

  has_many :blocked_commentators, dependent: :destroy
  has_many :random_contents, dependent: :destroy
  accepts_nested_attributes_for :random_contents, allow_destroy: true

  enum resource_platform: {
    facebook: 'facebook',
    instagram: 'instagram',
  }

  after_create :refresh_meta_access_token, if: -> { facebook? || instagram? }
  after_create :facebook_subscribed_fields, if: -> { facebook? }

  private

  def refresh_meta_access_token
    if saved_change_to_resource_access_token?
      remove_old_scheduled && RefreshMetaAccessTokenJob.perform_at(15.days.from_now, id)
    end
  end
 
  def remove_old_scheduled
    scheduled_set = Sidekiq::ScheduledSet.new
    scheduled_set.select do |scheduled|
      scheduled.klass == 'RefreshMetaAccessTokenJob' && scheduled.args[0] == id
    end.map(&:delete)
  end

  def facebook_subscribed_fields
    connect = Faraday.new(
      url: "https://graph.facebook.com/#{ ENV['FACEBOOK_VERSION'] }/#{ resource_id }/subscribed_apps?subscribed_fields=feed&access_token=#{ resource_access_token }",
      headers: {
        'Content-Type': 'application/json'
      }
    )

    connect.post
  end
end
