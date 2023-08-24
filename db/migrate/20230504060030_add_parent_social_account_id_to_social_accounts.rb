class AddParentSocialAccountIdToSocialAccounts < ActiveRecord::Migration[7.0]
  def change
    add_reference :social_accounts, :parent_social_account, index: true
  end
end
