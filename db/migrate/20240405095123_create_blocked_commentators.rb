class CreateBlockedCommentators < ActiveRecord::Migration[7.0]
  def change
    create_table :blocked_commentators do |t|
      t.string :post_id
      t.string :comment_id
      t.string :commentator_id
      t.references :social_account, foreign_key: true

      t.timestamps
    end
  end
end
