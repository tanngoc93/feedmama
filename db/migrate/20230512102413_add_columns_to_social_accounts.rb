class AddColumnsToSocialAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :social_accounts, :use_openai, :boolean, default: false
    add_column :social_accounts, :basic_comment, :text, default: ''
    add_column :social_accounts, :comment_length, :integer, default: 0
  end
end
