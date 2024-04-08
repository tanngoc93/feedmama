class CreateSocialAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :social_accounts do |t|
      t.boolean :status, default: false

      t.string  :resource_id, null: false
      t.string  :resource_name
      t.string  :resource_username
      t.string  :resource_platform, null: false
      t.string  :resource_access_token, null: true
      t.string  :resource_access_token_status, null: true

      t.boolean :processing_with_openai, default: false
      t.text    :openai_prompt_prebuild, default: "Please help me reply to this comment on Facebook, the comment content is \"#comment\". The commenter's name is \"#fullName\". Reply to them with appreciation, gratitude, or an empathetic comment. If someone says they miss someone, it's related to the content, not me. Comment length should not exceed 30 words. If the message is blank or you can't understand the context, give the person a cute song. Note: My Facebook page represents www.website.com, an online store dedicated to something..."
      t.integer :minimum_words_required_to_processing_with_openai, default: 0
      t.integer :time_blocking, default: 0
      t.integer :perform_at, default: 0

      t.references :user, index: true
      t.timestamps
    end
  end
end
