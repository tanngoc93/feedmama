class CreateSocialAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :social_accounts do |t|
      t.string  :resource_id, null: false
      t.string  :resource_name, null: false
      t.string  :resource_platform, null: false
      t.string  :resource_access_token, null: true
      t.text    :search_terms, default: "Please help me write a creative/engaging message to reply to a comment on my Facebook, the comment content is \"#comment\".\r\n\r\nThe commenter's name is \"#fullName\".\r\n\r\nDepending on the emotion of the comment, please help me reply to them with appreciation, gratitude, or an empathetic comment.\r\n\r\nBe kind, energetic, and full of love.\r\n\r\nAnd if possible choose an icon for the comment you make, it should match the emotion of the comment, for example, the comment's emotion is positive, happy should not choose the sad symbol, and vice versa.\r\n\r\nMake it 10 to 30 words long.\r\n\r\nIf the message is blank or you can't understand the context, give the person a cute song.\r\n\r\nNote: My Facebook page represents Someone/Something, an online store dedicated to custom jewelry as gifts for various occasions and for a wide audience, mainly between family members and their friends."
      t.boolean :active, default: false
      t.string  :verify_token
      t.string  :secured_token

      t.timestamps
    end
  end
end
