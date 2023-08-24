class CreateSocialAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :social_accounts do |t|
      t.string  :verify_token
      t.string  :secured_token
      t.boolean :status, default: false

      t.string  :resource_id, null: false
      t.string  :resource_name, null: false
      t.string  :resource_platform, null: false
      t.string  :resource_access_token, null: true

      t.boolean :use_openai, default: false
      t.text    :openai_prompt, default: "Please help me reply to this comment on Facebook, the comment content is \"#comment\". The commenter's name is \"#fullName\". Reply to them with appreciation, gratitude, or an empathetic comment. If someone says they miss someone, it's related to the content, not me. Comment length should not exceed 30 words. If the message is blank or you can't understand the context, give the person a cute song. Note: My Facebook page represents www.website.com, an online store dedicated to something..."
      t.integer :use_openai_when_comment_is_longer_in_length, default: 0
      t.integer :blocked_time, default: 3

      t.timestamps
    end
  end
end
