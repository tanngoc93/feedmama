class AddUserIdToSocialAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :social_accounts, :user_id, :integer
    add_index  :social_accounts, :user_id
  end
end
