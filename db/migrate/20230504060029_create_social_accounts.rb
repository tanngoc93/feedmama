class CreateSocialAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :social_accounts do |t|
      t.string  :resource_id, null: false
      t.string  :resource_name, null: false
      t.string  :resource_platform, null: false
      t.string  :resource_access_token, null: true
      t.text    :search_terms, null: true
      t.boolean :active, default: false
      t.string  :verify_token
      t.string  :secured_token

      t.timestamps
    end
  end
end
