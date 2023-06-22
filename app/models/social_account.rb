class SocialAccount < ApplicationRecord
  enum resource_platform: {
    facebook: 'facebook',
    instagram: 'instagram',
  }

  after_save :refresh_access_token

  private

  def refresh_access_token
    if facebook? && resource_access_token_changed?
      RefreshAccessTokenJob.perform_at(45.days.from_now, id)
    end
  end
end
