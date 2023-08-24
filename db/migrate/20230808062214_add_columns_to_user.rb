class AddColumnsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    add_column :users, :avatar, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
  end
end
