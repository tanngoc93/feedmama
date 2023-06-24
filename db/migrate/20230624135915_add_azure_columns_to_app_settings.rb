class AddAzureColumnsToAppSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :app_settings, :openai_uri, :string
    add_column :app_settings, :openai_type, :string
    add_column :app_settings, :openai_api_version, :string
  end
end
