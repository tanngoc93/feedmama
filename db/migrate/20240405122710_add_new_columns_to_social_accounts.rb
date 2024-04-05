class AddNewColumnsToSocialAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :social_accounts, :resource_access_token_error, :boolean, default: false 
    add_column :social_accounts, :time_blocking, :integer, default: 0
    add_column :social_accounts, :perform_at, :integer, default: 0
  end
end
