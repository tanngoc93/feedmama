class SocialAccount < ApplicationRecord
  has_many :auto_comments

  enum resource_platform: {
    facebook: 'facebook',
    instagram: 'instagram',
  }

  after_save :refresh_access_token

  private

  def refresh_access_token
    if facebook? && saved_change_to_resource_access_token?
      RefreshAccessTokenJob.perform_at(45.days.from_now, id)
    end
  end
end
