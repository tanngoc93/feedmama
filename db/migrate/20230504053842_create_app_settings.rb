class CreateAppSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :app_settings do |t|
      t.string  :verify_token
      t.string  :secured_token
      t.boolean :status, default: false

      t.integer :api_provider, default: 0, null: false
      t.string :api_endpoint
      t.string :api_model
      t.string :api_access_token
      t.string :api_version

      t.timestamps
    end
  end
end