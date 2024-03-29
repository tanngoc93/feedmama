class ChangeAutoCommentContentToUtf8mb4 < ActiveRecord::Migration[7.0]
  def up
    execute "ALTER TABLE auto_comments CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE auto_comments MODIFY content TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
  end

  def down
    execute "ALTER TABLE auto_comments CONVERT TO CHARACTER SET utf8 COLLATE utf8_bin"
    execute "ALTER TABLE auto_comments MODIFY content TEXT CHARACTER SET utf8 COLLATE utf8_bin"
  end
end
