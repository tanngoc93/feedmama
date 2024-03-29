ActiveAdmin.register AppSetting do
  menu priority: 2, label: 'General Setting'
  permit_params :status,
                :openai_token,
                :openai_model,
                :openai_uri,
                :openai_type,
                :openai_api_version,
                :facebook_permissions
                :instagram_permissions

  index do
    selectable_column
    id_column
    column :verify_token
    column :secured_token
    column :openai_model
    column :openai_type
    column :status
    actions
  end

  show do
    attributes_table do
      row :secured_token
      row :verify_token
      row :openai_model
      row :openai_type
      row :openai_api_version
      row :status
    end
  end

  filter :resource_platform

  form do |f|
    f.inputs do
      f.semantic_errors
      f.input :facebook_permissions
      f.input :openai_token
      f.input :openai_model
      f.input :openai_uri
      f.input :openai_type
      f.input :openai_api_version
      f.input :status
    end
    f.actions
  end
end
