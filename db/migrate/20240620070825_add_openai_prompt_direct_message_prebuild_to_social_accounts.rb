class AddOpenaiPromptDirectMessagePrebuildToSocialAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :social_accounts, :openai_prompt_direct_message_prebuild, :text, default: "Please help me reply to a Facebook message from \"#fullName\", the content: \"#message\". Send them back a thank you note or an encouraging comment. A comment should not exceed 25 or 30 words."
  end
end
