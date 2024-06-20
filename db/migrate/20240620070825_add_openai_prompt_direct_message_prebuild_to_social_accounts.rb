class AddOpenaiPromptDirectMessagePrebuildToSocialAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :social_accounts, :openai_prompt_direct_message_prebuild, :text, default: "Please help me reply to a user's message from Facebook, message content: \"#message\". Send them back a thank you note or an encouraging comment. Messages should not exceed 25 or 30 words."
  end
end
