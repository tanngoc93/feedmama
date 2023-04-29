class CreateSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :settings do |t|
      t.string :facebook_page_id
      t.string :facebook_page_access_token
      t.string :facebook_verify_token

      t.string :kind_of_bot
      t.string :bot_endpoint
      t.string :bot_token
      t.text   :input

      t.timestamps
    end
  end
end
