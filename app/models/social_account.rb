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

  validates :minimum_words_required_to_processing_with_openai,
            :time_blocking,
            :perform_at, presence: true

  validates :minimum_words_required_to_processing_with_openai,
            :time_blocking,
            :perform_at, numericality: { only_numeric: true }

  after_create :facebook_subscribed_fields, if: -> { facebook? }
  after_update :set_service_error_unlocker_job, if: -> { saved_change_to_service_error_status? }

  def owner_email
    self.user&.email
  end

  private

  def facebook_subscribed_fields
    connect = Faraday.new(
      url: "https://graph.facebook.com/#{ ENV['FACEBOOK_VERSION'] }/#{ resource_id }/subscribed_apps?subscribed_fields=feed&access_token=#{ resource_access_token }",
      headers: {
        'Content-Type': 'application/json'
      }
    )

    connect.post
  end

  def set_service_error_unlocker_job
    if service_error_status
      ServiceErrorUnlockerJob.perform_at(30.minutes, id)
    end
  end
end
