class AddColumnsToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :stripe_payment_link_id, :string
    add_column :orders, :product_quantity, :integer, default: 1
  end
end
