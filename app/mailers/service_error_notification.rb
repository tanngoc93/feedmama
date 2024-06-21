class ServiceErrorNotification < ApplicationMailer

  def send_email(social_account, error_code, error_at, error_message)
    @social_account = social_account
    @error_code = error_code
    @error_at = error_at
    @error_message = error_message

    if @social_account.owner_email
      mail(to: @social_account.owner_email,
        subject: 'Service Error Notification',
        template_path: 'mailers',
        template_name: 'service_error_notification')
    else
      Rails.logger.debug(">>>>>>>>>>>> #{self.class.name} - Email not found")
    end
  end
end
