class CreateRandomContents < ActiveRecord::Migration[7.0]
  def change
    create_table :random_contents do |t|
      t.text :content
      t.references :social_account, index: true

      t.timestamps
    end
  end
end
