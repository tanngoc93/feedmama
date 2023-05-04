class CreateAppSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :app_settings do |t|
      t.boolean :status, default: false
      t.string  :verify_token
      t.string  :secured_token
      t.string  :openai_token
      t.string  :openai_model

      t.timestamps
    end
  end
end
