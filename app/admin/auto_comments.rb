ActiveAdmin.register AutoComment do
  menu priority: 4, label: 'AutoComments Property'
  permit_params :content
                :social_account_id

  index do
    selectable_column
    column :content
    column :social_account_id
    actions
  end

  show do
    attributes_table do
      row :content
      row :social_account_id
    end
  end

  filter :resource_platform

  form do |f|
    f.inputs do
      f.input :content
      f.input :social_account_id, as: :select, collection: SocialAccount.all.collect { |item| [item.resource_name, item.id] }
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit auto_comment: [:content, :social_account_id]
    end
  end
end
