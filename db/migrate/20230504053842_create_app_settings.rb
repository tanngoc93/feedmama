class CreateAppSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :app_settings do |t|
      t.string  :verify_token
      t.string  :secured_token
      t.boolean :status, default: false

      t.string  :openai_type
      t.string  :openai_uri
      t.string  :openai_model
      t.string  :openai_token
      t.string  :openai_api_version

      t.string  :instagram_permissions
      t.string  :facebook_permissions

      t.timestamps
    end
  end
end