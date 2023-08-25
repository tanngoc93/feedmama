class AddColumnsToProducts < ActiveRecord::Migration[7.0]
  def change
    rename_column :products, :default_price, :price
    add_column :products, :stripe_price_id, :string
  end
end
