ActiveAdmin.register SocialAccount do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }
  permit_params :resource_id, :resource_name, :resource_platform, :resource_access_token, :search_terms, :active

  index do
    selectable_column
    id_column
    column :resource_id
    column :resource_name
    column :resource_platform
    column :created_at
    actions
  end

  filter :resource_platform

  form do |f|
    f.inputs do
      f.input :resource_id, label: "Account ID"
      f.input :resource_name, label: "Account Name"
      f.input :resource_platform, as: :select,  label: "Platform"
      f.input :resource_access_token,  label: "Access Token"
      f.input :search_terms
      f.input :active
    end
    f.actions
  end
end
