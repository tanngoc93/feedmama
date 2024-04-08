ActiveAdmin.register AppSetting do
  menu priority: 2, label: 'General Setting'
  permit_params :status,
                :api_provider,
                :api_endpoint,
                :api_model,
                :api_access_token,
                :api_endpoint,
                :api_version

  index do
    selectable_column
    id_column
    column :verify_token
    column :secured_token
    column :api_model
    column :api_type
    column :status
    actions
  end

  show do
    attributes_table do
      row :secured_token
      row :verify_token
      row :api_model
      row :api_provider
      row :api_version
      row :status
    end
  end

  filter :resource_platform

  form do |f|
    f.inputs do
      f.semantic_errors
      f.input :api_access_token
      f.input :api_model
      f.input :api_endpoint
      f.input :api_provider
      f.input :api_version
      f.input :status
    end
    f.actions
  end
end
