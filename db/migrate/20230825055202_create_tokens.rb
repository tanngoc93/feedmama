class CreateTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :tokens do |t|
      t.bigint     :amount, default: 0
      t.json       :token_details
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
