class AddUserIdToSocialAccounts < ActiveRecord::Migration[7.0]
  def change
    add_reference :social_accounts, :user, index: true
  end
end
