class CreateUserSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :user_settings do |t|
      t.status :status
      t.string :type
      t.string :provider
      t.string :endpoint
      t.string :model
      t.string :access_token
      t.string :api_version

      t.references :user, index: true
      t.timestamps
    end
  end
end
