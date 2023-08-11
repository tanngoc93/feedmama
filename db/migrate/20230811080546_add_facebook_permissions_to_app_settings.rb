class AddFacebookPermissionsToAppSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :app_settings, :facebook_permissions, :string
  end
end
