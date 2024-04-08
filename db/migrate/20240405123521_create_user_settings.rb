class CreateUserSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :user_settings do |t|
      t.integer :setting_status, default: 0, null: false
      t.integer :setting_type, default: 0, null: false
      t.integer :api_provider, default: 0, null: false
      t.string :api_endpoint
      t.string :api_model
      t.string :api_access_token
      t.string :api_version

      t.references :user, index: true
      t.timestamps
    end
  end
end
