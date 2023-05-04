class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.string :comment_id
      t.string :comment
      t.string :replied_comment

      t.timestamps
    end
  end
end
