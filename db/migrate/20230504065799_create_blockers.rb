class CreateBlockers < ActiveRecord::Migration[7.0]
  def change
    create_table :blockers do |t|
      t.string :post_id
      t.string :comment_id
      t.string :commentator_id
      t.references :social_accounts, foreign_key: true

      t.timestamps
    end
  end
end