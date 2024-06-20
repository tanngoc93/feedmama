class AddServiceErrorToSocialAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :social_accounts, :service_error_status, :boolean, default: false
    add_column :social_accounts, :service_error_at, :datetime
    add_column :social_accounts, :service_error_logs, :jsonb, default: []
  end
end
