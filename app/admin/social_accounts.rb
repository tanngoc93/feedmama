ActiveAdmin.register SocialAccount do
  menu priority: 3, label: 'SocialAccounts Property'
  permit_params :resource_id,
                :resource_name,
                :resource_platform,
                :resource_access_token,
                :parent_social_account_id,
                :use_openai_when_comment_is_longer_in_length,
                :use_openai,
                :openai_prompt,
                :blocked_time,
                :status

  index do
    selectable_column
    column :id
    column :resource_platform
    column :status
    column :use_openai
    column :resource_id
    column :resource_name
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :parent_social_account_id, label: 'Parent Page'
      row :resource_id, label: 'Account ID'
      row :resource_name, label: 'Account name'
      row :resource_platform, label: 'Platform'
      row :use_openai_when_comment_is_longer_in_length, label: 'Only reply to word-length comments'
      row :use_openai, label: 'Active?'
      row :status, label: 'Active?'
    end
  end

  filter :resource_platform

  form do |f|
    f.inputs do
      f.input :resource_platform, as: :select, label: "Platform"
      f.input :parent_social_account_id, as: :select, collection: SocialAccount.where(resource_platform: :facebook, status: true).collect { |item| ["#{item.resource_name} (#{item.resource_platform.capitalize})", item.id] }, label: "Facebook Page(If Instagram Platform)"
      f.input :resource_id, label: "Page/Connected Instagram ID"
      f.input :resource_name, label: "Page/Instagram Name"
      f.input :resource_access_token, label: "Access Token"
      f.input :openai_prompt, label: "Content Query", placeholder: raw("Note: #comment and #fullName are system variables and will be recognized and replaced by the system.\r\n\r\n\r\n\r\n Check out our example: \r\n\r\n\r\n\r\n Please help me write a creative/engaging message to reply to a comment on my Facebook, the comment content is \"#comment\".\r\n\r\nThe commenter's name is \"#fullName\".\r\n\r\nDepending on the emotion of the comment, please help me reply to them with appreciation, gratitude, or an empathetic comment.\r\n\r\nBe kind, energetic, and full of love.\r\n\r\nAnd if possible choose an icon for the comment you make, it should match the emotion of the comment, for example, the comment's emotion is positive, happy should not choose the sad symbol, and vice versa.\r\n\r\nMake it 10 to 30 words long.\r\n\r\nIf the message is blank or you can't understand the context, give the person a cute song.\r\n\r\nNote: My Facebook page represents Someone/Something, an online store dedicated to custom jewelry as gifts for various occasions and for a wide audience, mainly between family members and their friends.")
      f.input :use_openai_when_comment_is_longer_in_length, label: 'Only reply to word-length comments'
      f.input :use_openai, label: 'Use OpenAI to Reply?'
      f.input :status, label: 'Active?'
    end
    f.actions
  end
end
