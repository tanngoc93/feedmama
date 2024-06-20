class ServiceErrorUnlockerJob
  include Sidekiq::Job
  sidekiq_options retry: 3, dead: false

  def perform(social_account_id)
    social_account = SocialAccount.find_by(id: social_account_id)

    social_account&.update!(
      status: true,
      service_error_status: false,
      service_error_at: nil
    )
  rescue StandardError => e
    Rails.logger.debug(">>>>>>>>>>>> #{self.class.name} - #{e.message}")
  end
end
