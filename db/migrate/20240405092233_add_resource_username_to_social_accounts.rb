class AddResourceUsernameToSocialAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :social_accounts, :resource_username, :string
  end
end
