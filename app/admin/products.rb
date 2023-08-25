ActiveAdmin.register Product do
  menu priority: 4, label: 'Product'
  permit_params :name,
                :price,
                :status

  index do
    selectable_column
    column :name
    column :price
    column :status
    actions
  end

  show do
    attributes_table do
      row :name
      row :price
      row :status, label: 'Active?'
    end
  end

  filter :resource_platform

  form do |f|
    f.inputs do
      f.input :name
      f.input :price
      f.input :status
    end
    f.actions
  end
end
