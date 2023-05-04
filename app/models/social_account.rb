class SocialAccount < ApplicationRecord
  enum resource_platform: {
    facebook: 'facebook',
    instagram: 'instagram',
  }
end
